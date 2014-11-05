Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaKELvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 06:51:33 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64685 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaKELvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 06:51:32 -0500
Date: Wed, 5 Nov 2014 12:51:22 +0100
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: panel: Fix single-open policy race condition
Message-ID: <20141105115121.GA2592@firebird>
References: <1415137639-569-1-git-send-email-marius.gorski@gmail.com>
 <20141105101910.GO6879@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105101910.GO6879@mwanda>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 01:19:10PM +0300, Dan Carpenter wrote:
> On Tue, Nov 04, 2014 at 10:47:19PM +0100, Mariusz Gorski wrote:
> > Fix the implementation of a single-open policy for both
> > devices (lcd and keypad) by using atomic_t instead of plain ints.
> > 
> 
> This seems like it might be a real life bug that you have experienced?

No, I don't think it might really happen in real life. I found it just
by reading the code. A similar solution is used in Chapter 6 of the LDD3
book, so I thought it might be a good idea to fix is here.

> The changelog should tell the user visible effects of the bug.  If you
> have some dmesg output that would be helpful as well.

Nope, I can't really reproduce it ATM.

> regards,
> dan carpenter
> 

Cheers,
Mariusz
