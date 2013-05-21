Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab3EUMWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:22:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3EUMWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:22:52 -0400
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Severin Gsponer <svgsponer@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin McKinney <klmckinney1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: bcm: Fix of various code style issues.
References: <1368801862-24405-1-git-send-email-svgsponer@gmail.com>
Date: Tue, 21 May 2013 06:30:04 +0200
In-Reply-To: <1368801862-24405-1-git-send-email-svgsponer@gmail.com> (Severin
	Gsponer's message of "Fri, 17 May 2013 16:44:22 +0200")
Message-ID: <m3li79arar.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Severin Gsponer <svgsponer@gmail.com> writes:

> Changed comment style to C89 in Version.h
> Fixed some whitespace issues in Typedefs.h
> Changed comment style to C89 in vendorspecificextn.c
> All issues found with checkpatch.pl
>
> Signed-off-by: Severin Gsponer <svgsponer@gmail.com>
> ---
>  drivers/staging/bcm/Typedefs.h           |   22 ++--
>  drivers/staging/bcm/Version.h            |    8 +-
>  drivers/staging/bcm/vendorspecificextn.c |  197 +++++++++++++++---------------
>  3 files changed, 110 insertions(+), 117 deletions(-)
>
> diff --git a/drivers/staging/bcm/Typedefs.h b/drivers/staging/bcm/Typedefs.h
> index a985abf..3dea509 100644
> --- a/drivers/staging/bcm/Typedefs.h
> +++ b/drivers/staging/bcm/Typedefs.h
> @@ -25,16 +25,16 @@ typedef unsigned int B_UINT32;
>  typedef unsigned long ULONG;
>  typedef unsigned long DWORD;
>  
> -typedef char* PCHAR;
> -typedef short* PSHORT;
> -typedef int* PINT;
> -typedef long* PLONG;
> -typedef void* PVOID;
> -
> -typedef unsigned char* PUCHAR;
> -typedef unsigned short* PUSHORT;
> -typedef unsigned int* PUINT;
> -typedef unsigned long* PULONG;
> +typedef char *PCHAR;
> +typedef short *PSHORT;
> +typedef int *PINT;
> +typedef long *PLONG;
> +typedef void *PVOID;
> +
> +typedef unsigned char *PUCHAR;
> +typedef unsigned short *PUSHORT;
> +typedef unsigned int *PUINT;
> +typedef unsigned long *PULONG;
>  typedef unsigned long long ULONG64;
>  typedef unsigned long long LARGE_INTEGER;
>  typedef unsigned int UINT32;
> @@ -43,5 +43,5 @@ typedef unsigned int UINT32;
>  #endif

I bet, there is no reason for such typedef's

-- 
Nikola
