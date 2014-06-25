Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaFYUp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:45:58 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55334 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaFYUp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:45:56 -0400
Date: Wed, 25 Jun 2014 21:45:54 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] efilinux: Allocate boot_params before parsing initrd
Message-ID: <20140625204554.GE15494@console-pimps.org>
References: <1403073669-6602-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403073669-6602-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun, at 11:41:08PM, Yinghai Lu wrote:
> We need to allocate boot_params early and clear it before copy
> setup_header to it.
> 
> So kernel will not call sanitize_boot_params() to overwrite new
> added parameter like ext_ramdisk_image, ext_ramdisk_size...
> 
> We should modify boot_params later instead of touch temp buf too early.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  loaders/bzimage/bzimage.c |   65 ++++++++++++++++++++++++----------------------
>  1 file changed, 34 insertions(+), 31 deletions(-)
 
Applied, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
