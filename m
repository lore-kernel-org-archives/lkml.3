Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaF0GYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 02:24:12 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:46009 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaF0GYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 02:24:09 -0400
Date: Fri, 27 Jun 2014 07:24:06 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] efilinux: set ext_ramdisk_* for huge initrd
Message-ID: <20140627062406.GA7539@console-pimps.org>
References: <1403731467-1527-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403731467-1527-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun, at 02:24:27PM, Yinghai Lu wrote:
> We could load it high if it is more than 2G when kernel support
> LOAD_ABOVE_4G.
> 
> -v2: Use macro instead of (1<<1) directly for LOAD_ABOVE_4G.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  loaders/bzimage/bzimage.c |    9 ++++++++-
>  loaders/bzimage/bzimage.h |   15 +++++++++++++--
>  2 files changed, 21 insertions(+), 3 deletions(-)

Applied, thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
