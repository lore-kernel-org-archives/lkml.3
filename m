Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbaGCSEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:04:55 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:56443 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbaGCSEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:04:53 -0400
Message-ID: <1404410691.16291.11.camel@x220>
Subject: Re: [PATCH 2/2] mach-spear: fixed spear1340.c file
From: Paul Bolle <pebolle@tiscali.nl>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: viresh.linux@gmail.com, shiraz.linux.kernel@gmail.com,
        linux@arm.linux.org.uk, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Jul 2014 20:04:51 +0200
In-Reply-To: <1404354994-7478-1-git-send-email-xerofoify@gmail.com>
References: <1404354994-7478-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2014 18:04:51.0602 (UTC) FILETIME=[49293F20:01CF96E9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 22:36 -0400, Nicholas Krause wrote:
> This is the fixed file after moving sata support to new file in
> spear1340_sata.c
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/arm/mach-spear/spear1340.c | 111 ----------------------------------------
>  1 file changed, 111 deletions(-)

This patch, together with patch 1/2, basically moves a chunk of code
into a separate file, didn't it? If so, why did you split that move in
two patches?

And how does all this work without any changes to a Makefile?

> diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
> index 7b6bff7..f9d8ef3 100644
> --- a/arch/arm/mach-spear/spear1340.c
> +++ b/arch/arm/mach-spear/spear1340.c
> @@ -21,117 +21,6 @@
>  #include "generic.h"
>  #include <mach/spear.h>
>  
> -/* FIXME: Move SATA PHY code into a standalone driver */

(I have no idea what this FIXME is about, but I do wonder whether that
new file by itself is the standalone driver this FIXME is about. The
spear developers will surely know.)


Paul Bolle

