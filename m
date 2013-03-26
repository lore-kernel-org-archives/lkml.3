Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741Ab3CZAkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:40:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48275 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819Ab3CZAkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:40:11 -0400
Date: Mon, 25 Mar 2013 19:40:06 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] doc: change example to existing Makefile fragment
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
References: <1364206584.1390.268.camel@x61.thuisdomein>
In-Reply-To: <1364206584.1390.268.camel@x61.thuisdomein> (from
	pebolle@tiscali.nl on Mon Mar 25 05:16:24 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1364258406.15703.70@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 05:16:24 AM, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  Documentation/kbuild/makefiles.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Acked-by: Rob Landley <rob@landley.net>

Please send through the kbuild tree.

Rob

> diff --git a/Documentation/kbuild/makefiles.txt  
> b/Documentation/kbuild/makefiles.txt
> index 5198b74..020bb67 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -921,8 +921,9 @@ When kbuild executes, the following steps are  
> followed (roughly):
>  	Often, the KBUILD_CFLAGS variable depends on the configuration.
> 
>  	Example:
> -		#arch/x86/Makefile
> -		cflags-$(CONFIG_M386) += -march=i386
> +		#arch/x86/boot/compressed/Makefile
> +		cflags-$(CONFIG_X86_32) := -march=i386
> +		cflags-$(CONFIG_X86_64) := -mcmodel=small
>  		KBUILD_CFLAGS += $(cflags-y)
> 
>  	Many arch Makefiles dynamically run the target C compiler to
> --
> 1.7.11.7
> 
> 
> 
> 

