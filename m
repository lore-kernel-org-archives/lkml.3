Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761098AbaJaGt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:49:26 -0400
Received: from submit1.sa.ew.hu ([212.108.200.71]:41623 "EHLO submit1.sa.ew.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbaJaGtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:49:25 -0400
Message-ID: <545330EA.60303@denx.de>
Date: Fri, 31 Oct 2014 07:49:14 +0100
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: lsorense@csclub.uwaterloo.ca, linux-kernel@vger.kernel.org,
        mugunthanvnm@ti.com, netdev@vger.kernel.org
Subject: Re: Mistake in commit 0d961b3b52f566f823070ce2366511a7f64b928c breaks
 cpsw non dual_emac mode.
References: <20141028170242.GA24112@csclub.uwaterloo.ca> <20141030.154323.1702996635200338108.davem@davemloft.net>
In-Reply-To: <20141030.154323.1702996635200338108.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1600_1699 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __FORWARDED_MSG 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_REPLYTO 0, __IN_REP_TO 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __REPLYTO_SAMEAS_FROM_ACC 0, __REPLYTO_SAMEAS_FROM_ADDY 0, __REPLYTO_SAMEAS_FROM_DOMAIN 0, __SANE_MSGID 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David, Lennart,

Am 30.10.2014 20:43, schrieb David Miller:
> From: "Lennart Sorensen"<lsorense@csclub.uwaterloo.ca>
> Date: Tue, 28 Oct 2014 13:02:42 -0400
>
>> I believe commit 0d961b3b52f566f823070ce2366511a7f64b928c made a mistake
>> while correcting a bug.

Seems I missed your original patch ... looked in it here:

https://lkml.org/lkml/2014/10/28/837

and I think you are correct, thanks for this fix. You can add my
Acked-by: Heiko Schocher <hs@denx.de>
if you post a corrected v2, as David suggested.

bye,
Heiko

> This patch submission is not properly formed.
>
> You subject line should be of the form:
>
> subsystem: Description.
>
> "subsystem" here would be "cpsw: " or something like that.
>
> Secondly, you should not refer to a commit ID in the patch
> Subject line, instead just describe exactly what is being
> fixed in the most succinct yet complete manner that is
> possible.
>
> Thirdly, when you do refer to commit ID's in your commit
> message body you must do so in the following format:
>
> ${SHA1_ID} ("Commit message header line text.")
>
> The commit message body is also not a place to have a general
> discussion.  Please avoid saying things like "I think", for example.
> State facts, and be exact about what the problem is and exactly
> how you are fixing it.
>
> Because this commit message will be read by others looking at your
> change days, weeks, years from now.
>
> Thanks.
>

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
