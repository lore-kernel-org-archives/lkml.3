Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaHUKuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:50:04 -0400
Received: from submit1.sa.ew.hu ([212.108.200.71]:55775 "EHLO submit1.sa.ew.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbaHUKuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:50:01 -0400
Message-ID: <53F5CED3.2040107@denx.de>
Date: Thu, 21 Aug 2014 12:49:55 +0200
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Vince Hsu <vinceh@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Handling commit change logs
References: <1408419205-10048-1-git-send-email-tuomas.tynkkynen@iki.fi> <1408419205-10048-14-git-send-email-tuomas.tynkkynen@iki.fi> <CAKohpokQOALPH13Ykz4nTBOby8J1X6_F30LNKz=gsC4wN3=3vg@mail.gmail.com> <53F3A900.8010805@nvidia.com> <CAKohponcZv9-MFNUQFxC_49-+P6QOhdjxsnYAyL3i4sXdCBYrw@mail.gmail.com> <CABxcv=ncm3Y7Ecfymro6TOuP=d10OV5--8n=dYmHyj6zi8hwEw@mail.gmail.com> <53F4FED4.7060408@suse.de> <53F50554.3050505@wwwdotorg.org> <CAOh2x=mO1r76fkvruvBLaL144G8fHgDPMwhKVCxv4HW8FRUE_Q@mail.gmail.com> <53F58DFD.900@denx.de> <CABxcv=kJixq0WW5YEX-LvBfU-e9_0pkPw5JeHFOWz8h-_eSjyg@mail.gmail.com>
In-Reply-To: <CABxcv=kJixq0WW5YEX-LvBfU-e9_0pkPw5JeHFOWz8h-_eSjyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-PMX-Spam: Gauge=XXIIIIIIII, Probability=28%, Report='
 SXL_IP_DYNAMIC 3, MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1100_1199 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __FORWARDED_MSG 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_REPLYTO 0, __IN_REP_TO 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __REPLYTO_SAMEAS_FROM_ACC 0, __REPLYTO_SAMEAS_FROM_ADDY 0, __REPLYTO_SAMEAS_FROM_DOMAIN 0, __SANE_MSGID 0, __SUBJ_ALPHA_END 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Javier,

Am 21.08.2014 12:35, schrieb Javier Martinez Canillas:
> Hello Heiko,
>
> On Thu, Aug 21, 2014 at 8:13 AM, Heiko Schocher<hs@denx.de>  wrote:
>> Hello Viresh,
>>
>> Am 21.08.2014 06:26, schrieb Viresh Kumar:
>>
>>> On Thu, Aug 21, 2014 at 2:00 AM, Stephen Warren<swarren@wwwdotorg.org>
>>> wrote:
>>>>
>>>> On 08/20/2014 02:02 PM, Andreas Färber wrote:
>>>>>
>>>>> Am 20.08.2014 17:39, schrieb Javier Martinez Canillas:
>>>>>>
>>>>>> If this not the correct workflow and you have a better way to manage
>>>>>> this, I would love to know about it.
>>>
>>>
>>> Oh yes, this was certainly useful. I was missing this (mis)feature :)
>>
>>
>> maybe patman from u-boot is also interesting for you, see:
>>
>> http://git.denx.de/?p=u-boot.git;a=blob;f=tools/patman/README;h=5fb508b80df10d3b11d95eea95a141ce3d0ef578;hb=67ee22b0681305ba1099c508eecade996abc1c65
>>
>
> Very interesting and seems to match my workflow as well so I'll take a
> look, thanks for sharing!

You are welcome!

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
