Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaBMLGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:06:32 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:39494 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbaBMLGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:06:30 -0500
Date: Thu, 13 Feb 2014 11:06:25 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firmware/efi : use NULL instead of 0 for pointer
Message-ID: <20140213110625.GD20717@console-pimps.org>
References: <2817765.zrQqrE3135@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2817765.zrQqrE3135@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Feb, at 06:54:48PM, Daeseok Youn wrote:
> From 1c70573009a3b50cef2acaae1e5a8cd350edfe6d Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Thu, 13 Feb 2014 17:16:36 +0900
> Subject: [PATCH] firmware/efi : use NULL instead of 0 for pointer
> 
> following sparse warnings:
> 
> drivers/firmware/efi/efivars.c:230:66: warning:
>  Using plain integer as NULL pointer
> drivers/firmware/efi/efi.c:236:27: warning:
>  Using plain integer as NULL pointer
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  drivers/firmware/efi/efi.c     |    2 +-
>  drivers/firmware/efi/efivars.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

This patch doesn't apply because it is corrupt,

  fatal: corrupt patch at line 11
  Patch failed at 0001 efi: Use NULL instead of 0 for pointer

Please attach the patch in a reply.

-- 
Matt Fleming, Intel Open Source Technology Center
