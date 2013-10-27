Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3J0I0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 04:26:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34152 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3J0I0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 04:26:05 -0400
Date: Sun, 27 Oct 2013 11:25:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kevin McKinney <klmckinney1@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] Staging: bcm: Replace UCHAR with unsigned char in
 Adapter.h
Message-ID: <20131027082555.GM5871@mwanda>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
 <1382768120-23380-4-git-send-email-klmckinney1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382768120-23380-4-git-send-email-klmckinney1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 02:15:13AM -0400, Kevin McKinney wrote:
> This patch replace "UCHAR" with "unsigned
> char" in Adapter.h

I feel like these should pretty much all be u8 instead of "unsigned
char".

regards,
dan carpenter

