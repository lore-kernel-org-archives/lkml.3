Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab3LIKBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:01:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab3LIKBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:01:32 -0500
Message-ID: <52A594FB.6020700@suse.de>
Date: Mon, 09 Dec 2013 11:01:31 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] [SCSI] aic7xxx: remove duplicate define
References: <1382524483-3167-1-git-send-email-michael.opdenacker@free-electrons.com> <1386582956-4942-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1386582956-4942-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 10:55 AM, Michael Opdenacker wrote:
> Remove duplicate define
> in drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
> index 9df9e2ce3538..8373447bd7d3 100644
> --- a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
> +++ b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
> @@ -209,7 +209,6 @@ struct instruction {
>  #define AIC_OP_JC16	0x9105
>  #define AIC_OP_JNC16	0x9205
>  #define AIC_OP_CALL16	0x9305
> -#define AIC_OP_CALL16	0x9305
>  
>  /* Page extension is low three bits of second opcode byte. */
>  #define AIC_OP_JMPF	0xA005
> 
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
