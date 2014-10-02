Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaJBWhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 18:37:38 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:38355 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaJBWhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 18:37:37 -0400
Date: Thu, 2 Oct 2014 18:37:26 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: rdunlap@infradead.org, trivial@kernel.org, joe@perches.com,
        akpm@linux-foundation.org, arend@broadcom.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of "the the "
Message-ID: <20141002223724.GA11578@developer>
References: <542DB1F3.6030609@free-electrons.com>
 <1412280903-6139-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412280903-6139-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 10:15:03PM +0200, Michael Opdenacker wrote:
> Fix all occurrences of "the the ", and occasionally "in in ",
> in the source code, comments and documentation.
> 
> The replacement couldn't be automated because sometimes
> the first "the" was meant to be another word.
> 
> Example: "according the the"
> meaning: "according to the"
> 
> Note that I sometimes took the opportunity to fix
> other spelling issues or typos in the same sentences,
> and to reformat some comments impacted by the changes.
> 
> I also fixed a few checkpatch errors in the same
> lines, but not all of them (should be addressed by
> separate patches).
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Reviewed-by: rdunlap@infradead.org
> ---

<cut>

>  tools/thermal/tmon/pid.c                                     |  2 +-
>  225 files changed, 266 insertions(+), 266 deletions(-)
> 

<big cut>

> diff --git a/tools/thermal/tmon/pid.c b/tools/thermal/tmon/pid.c
> index fd7e9e9d6f4a..1aa7faa0e0e0 100644
> --- a/tools/thermal/tmon/pid.c
> +++ b/tools/thermal/tmon/pid.c
> @@ -38,7 +38,7 @@
>  
>  /**************************************************************************
>   * PID (Proportional-Integral-Derivative) controller is commonly used in
> - * linear control system, consider the the process.
> + * linear control system, consider the process.


On Tmon behalf:

Acked-by: Eduardo Valentin <edubezval@gmail.com>

>   * G(s) = U(s)/E(s)
>   * kp = proportional gain
>   * ki = integral gain
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
