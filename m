Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaFQLBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:01:50 -0400
Received: from submit2.sa.ew.hu ([212.108.200.72]:49108 "EHLO submit2.sa.ew.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbaFQLBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:01:48 -0400
Message-ID: <53A02013.1060403@denx.de>
Date: Tue, 17 Jun 2014 13:01:39 +0200
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4] hwmon: Driver for TI TMP103 temperature sensor
References: <1402992713-22711-1-git-send-email-hs@denx.de> <53A01CE6.4010608@roeck-us.net>
In-Reply-To: <53A01CE6.4010608@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Spam: Gauge=XXXIIII, Probability=34%, Report='
 SXL_IP_DYNAMIC 3, HASHBUSTER_BLOCK_V2 0.5, MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_900_999 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __FORWARDED_MSG 0, __HASHBUSTER_BLOCK_V2_1 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_REPLYTO 0, __IN_REP_TO 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __REPLYTO_SAMEAS_FROM_ACC 0, __REPLYTO_SAMEAS_FROM_ADDY 0, __REPLYTO_SAMEAS_FROM_DOMAIN 0, __SANE_MSGID 0, __SUBJ_ALPHA_END 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Guenter

Am 17.06.2014 12:48, schrieb Guenter Roeck:
> On 06/17/2014 01:11 AM, Heiko Schocher wrote:
>> Driver for the TI TMP103.
>>
>> The TI TMP103 is similar to the TMP102. It differs from the TMP102
>> by having only 8 bit registers.
>>
>> Signed-off-by: Heiko Schocher <hs@denx.de>
>>
> [ ... ]
>> +#define TMP103_CONF_SD (TMP103_CONF_M0 | TMP103_CONF_M1)
>
> Hello Heiko,
>
> I thought this needs to be TMP103_CONF_M1, but from the datasheet it looks
> like it does not matter if M0 is set if M1 is set as well. Did you test it,
> though, to make sure that it works ? I feel slightly uncomfortable with it.

Yes, i tested it on an imx6 based board. I see no issues ... but I can
test it with "#define TMP103_CONF_SD TMP103_CONF_M1" and post a v5 with
this setting if it works ...

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
