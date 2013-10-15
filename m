Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471Ab3JOGOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:14:45 -0400
Received: from mailout-m0-k.invitel.net ([91.82.116.154]:54987 "EHLO
	relay-m2-k.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab3JOGOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:14:43 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2013 02:14:42 EDT
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
X-Invitel-SMTP-Policy: accepting mail on this level
Message-ID: <525CDB51.70408@denx.de>
Date: Tue, 15 Oct 2013 08:06:09 +0200
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, khali@linux-fr.org,
        ben-linux@fluff.org, grant.likely@secretlab.ca, sjg@chromium.org,
        naveenkrishna.ch@gmail.com, d.mueller@elsoft.ch, trini@ti.com,
        mk7.kang@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH 1/3 v3] exynos: i2c: Fix i2c driver to handle NACKs properly
References: <1380799354-14460-1-git-send-email-ch.naveen@samsung.com> <1381813971-16006-1-git-send-email-ch.naveen@samsung.com>
In-Reply-To: <1381813971-16006-1-git-send-email-ch.naveen@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Spam: Gauge=XXIIIIIIII, Probability=28%, Report='
 SXL_IP_DYNAMIC 3, MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_1099 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, ECARD_KNOWN_DOMAINS 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __FORWARDED_MSG 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_REPLYTO 0, __IN_REP_TO 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __REPLYTO_SAMEAS_FROM_ACC 0, __REPLYTO_SAMEAS_FROM_ADDY 0, __REPLYTO_SAMEAS_FROM_DOMAIN 0, __SANE_MSGID 0, __SUBJ_ALPHA_END 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Naveen,

Am 15.10.2013 07:12, schrieb Naveen Krishna Chatradhi:
> The Exynos5 i2c driver does not handle NACKs properly. This change:
>
> - fixes the NACK processing problem (do not continue transaction if
>    address cycle was NACKed)
>
> - eliminates a fair amount of duplicate code
>
> Signed-off-by: Vadim Bendebury<vbendeb@chromium.org>
> Reviewed-by: Simon Glass<sjg@google.com>
> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
> ---
> Changes since v1:
> Fixed complilation warning in function i2c_init()
>
> Changes since v2:
> None
>
>   drivers/i2c/s3c24x0_i2c.c |  214 +++++++++++++++++++--------------------------
>   1 file changed, 90 insertions(+), 124 deletions(-)

Hmm.. I think your patchset is for u-boot, or? But I could not find
the u-boot ml on cc... instead some linux ml ... if so, please resend
to the u-boot ml ...

(matches for all three patches from you)

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
