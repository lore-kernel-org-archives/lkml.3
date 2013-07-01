Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3GASmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:42:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab3GASmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:42:14 -0400
Date: Mon, 1 Jul 2013 11:42:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.4-stable] mmc: block: fix a bug of error handling in
 MMC driver
Message-ID: <20130701184213.GD11648@kroah.com>
References: <1368165727-32125-1-git-send-email-yoshitake.kobayashi@toshiba.co.jp>
 <1372665385-8993-1-git-send-email-yoshitake.kobayashi@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372665385-8993-1-git-send-email-yoshitake.kobayashi@toshiba.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 04:56:25PM +0900, KOBAYASHI Yoshitake wrote:
> Backport for 3.4-stable for the following patch:
>      https://lkml.org/lkml/2013/5/10/20

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
