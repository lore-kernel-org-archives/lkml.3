Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaGVHWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:22:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaGVHWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:22:12 -0400
Date: Tue, 22 Jul 2014 00:21:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kiran Padwal <kiran.padwal21@gmail.com>
Cc: devel@driverdev.osuosl.org, gulsah.1004@gmail.com, wkang77@gmail.com,
        rusty@rustcorp.com.au, valentina.manea.m@gmail.com,
        linux-kernel@vger.kernel.org, deanahn@gctsemi.com,
        rashika.kheria@gmail.com, joe@perches.com, jonathankim@gctsemi.com
Subject: Re: [PATCH] Staging: gdm724x: gdm_lte.c: Fix warning of prefer
 ether_addr_copy()
Message-ID: <20140722072148.GA11054@kroah.com>
References: <1406012202-31208-1-git-send-email-kiran.padwal21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406012202-31208-1-git-send-email-kiran.padwal21@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 12:26:42PM +0530, Kiran Padwal wrote:
> This patch fixes the following checkpatch.pl warnings:
> WARNING: "Prefer ether_addr_copy() over memcpy() if the Ethernet addresses are __aligned(2)".

Is that true here?

Have you tested this on the hardware to ensure it works properly?

I hate that checkpatch message...

thanks,

greg k-h
