Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbaEGMj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:39:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39529 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaEGMj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:39:28 -0400
Date: Wed, 7 May 2014 15:39:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: John Church <sleeveroller@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        georgiana.chelu93@gmail.com, waydi1@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging : android: Fixes a coding style issue in
 timed_gpio.c
Message-ID: <20140507123915.GA26890@mwanda>
References: <1399465802-9309-1-git-send-email-sleeveroller@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399465802-9309-1-git-send-email-sleeveroller@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder if there is some kind of tutorial which teaches people to
choose the least specific subject possible?  We should find which
tutorial it is and update it.  John, can you give us a hint here which
tutorial you are using?

On Wed, May 07, 2014 at 01:30:02PM +0100, John Church wrote:
> This patch fixes a coding style issue for a line that was over 80 characters long.
> 
> Signed-off-by: John Church <sleeveroller@gmail.com>

Anyway, looks ok.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

