Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaKEKTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:19:39 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32322 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKEKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:19:37 -0500
Date: Wed, 5 Nov 2014 13:19:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: panel: Fix single-open policy race condition
Message-ID: <20141105101910.GO6879@mwanda>
References: <1415137639-569-1-git-send-email-marius.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415137639-569-1-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:47:19PM +0100, Mariusz Gorski wrote:
> Fix the implementation of a single-open policy for both
> devices (lcd and keypad) by using atomic_t instead of plain ints.
> 

This seems like it might be a real life bug that you have experienced?

The changelog should tell the user visible effects of the bug.  If you
have some dmesg output that would be helpful as well.

regards,
dan carpenter

