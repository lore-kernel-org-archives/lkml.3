Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbbARSHr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:07:47 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:53685 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbbARSHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:07:46 -0500
Date: Sun, 18 Jan 2015 19:07:40 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts/recordmcount.pl: There is no -m32 option on
 Super-H
Message-ID: <20150118180740.GA3587@osiris>
References: <1421537778-29001-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421537778-29001-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011818-0013-0000-0000-000002A56B36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 12:36:15AM +0100, Michael Karcher wrote:
> Signed-Off-By: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> ---
>  scripts/recordmcount.pl | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> index 56ea99a..537c38c 100755
> --- a/scripts/recordmcount.pl
> +++ b/scripts/recordmcount.pl
> @@ -255,7 +255,6 @@ if ($arch eq "x86_64") {
>      # force flags for this arch
>      $ld .= " -m shlelf_linux";
>      $objcopy .= " -O elf32-sh-linux";
> -    $cc .= " -m32";
> 
>  } elsif ($arch eq "powerpc") {
>      $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
> -- 
> 2.1.3

The Super-H architecure seems to be without any maintainer.
Maybe Steven cares to pick this patch up. Dunno...

