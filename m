Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965469Ab3FTLsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:48:09 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58078 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965093Ab3FTLsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <1371726701-24970-1-git-send-email-nicolas.palix@imag.fr>
References: <1371726701-24970-1-git-send-email-nicolas.palix@imag.fr>
Date: Thu, 20 Jun 2013 17:18:06 +0530
Message-ID: <CAK9yfHyM7OrOtxWN56J06RAVBc-q0idDdhFjYzT3=opw-bZuXA@mail.gmail.com>
Subject: Re: [PATCH 2/3] Coccinelle: Update the documentation
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Michal Marek <mmarek@suse.cz>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 June 2013 16:41, Nicolas Palix <nicolas.palix@imag.fr> wrote:
>  - The new default mode is 'report'.
>  - The available modes are detailed a bit more.
>  - Some information about the use of spatch options are
>    also given concerning the use of indexing tools.
>
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
> ---
>  Documentation/coccinelle.txt |   39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index 408439d..1aa9a40 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -48,7 +48,7 @@ A Coccinelle-specific target is defined in the top level
>  Makefile. This target is named 'coccicheck' and calls the 'coccicheck'
>  front-end in the 'scripts' directory.
>
> -Four modes are defined: patch, report, context, and org. The mode to
> +Four basic modes are defined: patch, report, context, and org. The mode to
>  use is specified by setting the MODE variable with 'MODE=<mode>'.
>
>  'patch' proposes a fix, when possible.
> @@ -62,18 +62,24 @@ diff-like style.Lines of interest are indicated with '-'.
>  'org' generates a report in the Org mode format of Emacs.
>
>  Note that not all semantic patches implement all modes. For easy use
> -of Coccinelle, the default mode is "chain" which tries the previous
> -modes in the order above until one succeeds.
> +of Coccinelle, the default mode is "report".
>
> -To make a report for every semantic patch, run the following command:
> +Two other modes provide some common combinaisons of these modes.
>

s/combinaisons/combinations


-- 
With warm regards,
Sachin
