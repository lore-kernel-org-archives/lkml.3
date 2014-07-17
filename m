Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbaGQLoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:44:22 -0400
Received: from submit1.sa.ew.hu ([212.108.200.71]:42048 "EHLO submit1.sa.ew.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbaGQLoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:44:20 -0400
Message-ID: <53C7B70F.5040904@denx.de>
Date: Thu, 17 Jul 2014 13:44:15 +0200
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linuxppc-dev@lists.ozlabs.org, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Larsson <andreas@gaisler.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: Re: spi, spi_fsl-spi.c not working?
References: <53C79351.2080406@denx.de> <20140717113129.GU17528@sirena.org.uk>
In-Reply-To: <20140717113129.GU17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Spam: Gauge=XXIIIIIIII, Probability=28%, Report='
 SXL_IP_DYNAMIC 3, MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_400_499 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __FORWARDED_MSG 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_REPLYTO 0, __IN_REP_TO 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __REPLYTO_SAMEAS_FROM_ACC 0, __REPLYTO_SAMEAS_FROM_ADDY 0, __REPLYTO_SAMEAS_FROM_DOMAIN 0, __SANE_MSGID 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

Am 17.07.2014 13:31, schrieb Mark Brown:
> On Thu, Jul 17, 2014 at 11:11:45AM +0200, Heiko Schocher wrote:
>
>> Is it maybe the missing "support for the SPI subsystem's queue SPI messages"?
>
> It shouldn't be that, that's still optional (sadly).

Thanks for this info! I digging in it ...

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
