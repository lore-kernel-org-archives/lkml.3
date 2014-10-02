Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaJBRZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:25:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaJBRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:25:17 -0400
Message-ID: <542D8A7C.6080908@infradead.org>
Date: Thu, 02 Oct 2014 10:25:16 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        trivial@kernel.org, joe@perches.com, akpm@linux-foundation.org,
        arend@broadcom.com, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of "the the
 "
References: <542C5ACB.70001@free-electrons.com> <1412193293-8835-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1412193293-8835-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few corrections for you.


On 10/01/14 12:54, Michael Opdenacker wrote:
> Fix all occurrences of "the the " in the source code,
> comments and documentation.
> 

and occasionally "in in "

> The replacement couldn't be automated because sometimes
> the first "the" was meant to be another word.
> 
> Example: "according the the"
> meaning: "according to the"
> 
> Note that I sometimes took the opportunity to fix
> other spelling issues or typos in the same sentences.
> I also fixed a few checkpatch errors in the same
> lines, but not all of them (should be addressed by
> separate patches).

including reformatting of some comments.

> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  225 files changed, 263 insertions(+), 263 deletions(-)

> diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
> index 82bbfa5a05b3..5f2cdfe6f0c2 100644
> --- a/arch/xtensa/kernel/entry.S
> +++ b/arch/xtensa/kernel/entry.S
> @@ -830,14 +830,14 @@ ENDPROC(unrecoverable_exception)
>   * of the proper size instead.
>   *
>   * This algorithm simply backs out the register changes started by the user
> - * excpetion handler, makes it appear that we have started a window underflow
> + * exception handler, makes it appear that we have started a window underflow
>   * by rotating the window back and then setting the old window base (OWB) in
>   * the 'ps' register with the rolled back window base. The 'movsp' instruction
>   * will be re-executed and this time since the next window frames is in the
>   * active AR registers it won't cause an exception.
>   *
>   * If the WindowUnderflow code gets a TLB miss the page will get mapped
> - * the the partial windeowUnderflow will be handeled in the double exception
> + * and the partial windeowUnderflow will be handeled in the double exception

                                               handled

>   * handler.
>   *
>   * Entry condition:

> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
> index a1f1127d7808..f3aa063dee4b 100644
> --- a/drivers/net/wireless/ath/wcn36xx/hal.h
> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
> @@ -1609,7 +1609,7 @@ struct wcn36xx_hal_config_bss_params {
>  
>  	/* HAL should update the existing BSS entry, if this flag is set.
>  	 * UMAC will set this flag in case of reassoc, where we want to
> -	 * resue the the old BSSID and still return success 0 = Add, 1 =
> +	 * reuse the old BSSID and still return success 0 = Add, 1 =
>  	 * Update */
>  	u8 action;
>  
> @@ -1746,7 +1746,7 @@ struct wcn36xx_hal_config_bss_params_v1 {
>  
>  	/* HAL should update the existing BSS entry, if this flag is set.
>  	 * UMAC will set this flag in case of reassoc, where we want to
> -	 * resue the the old BSSID and still return success 0 = Add, 1 =
> +	 * reuse the old BSSID and still return success 0 = Add, 1 =
>  	 * Update */
>  	u8 action;
>  
> @@ -3739,7 +3739,7 @@ struct wcn36xx_hal_dump_cmd_rsp_msg {
>  	/* Length of the responce message */
>  	u32 rsp_length;
>  
> -	/* FIXME: Currently considering the the responce will be less than
> +	/* FIXME: Currently considering that the responce will be less than

	                                         response

>  	 * 100bytes */
>  	u8 rsp_buffer[DUMPCMD_RSP_BUFFER];
>  } __packed;

> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index fbc5ebb5f761..d06dd9316716 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -410,8 +410,8 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
>  			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>  		} else {
>  			/*
> -			 * Extract the RELATIVE TARGET PORT IDENTIFIER to identify
> -			 * the Target Port in question for the the incoming
> +			 * Extact the RELATIVE TARGET PORT IDENTIFIER to identify

			   Extract

> +			 * the Target Port in question for the incoming
>  			 * SET_TARGET_PORT_GROUPS op.
>  			 */
>  			rtpi = get_unaligned_be16(ptr + 2);

> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> index 158701da2d31..c13e0636ea44 100644
> --- a/net/sctp/chunk.c
> +++ b/net/sctp/chunk.c
> @@ -199,8 +199,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  		sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk)) & ~3;
>  
>  	max = asoc->frag_point;
> -	/* If the the peer requested that we authenticate DATA chunks
> -	 * we need to account for bundling of the AUTH chunks along with
> +	/* If the peer requested that we authenticate DATA chunks
> +	 * we need to accound for bundling of the AUTH chunks along with

	              account (original was correct)
>  	 * DATA.
>  	 */
>  	if (sctp_auth_send_cid(SCTP_CID_DATA, asoc)) {


-- 
~Randy
