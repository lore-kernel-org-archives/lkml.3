Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaDXISN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:18:13 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:52059
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751787AbaDXISG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:18:06 -0400
X-WSS-ID: 0N4J0E1-07-3LZ-02
X-M-MSG: 
Message-ID: <5358C8B5.7020609@amd.com>
Date: Thu, 24 Apr 2014 10:17:57 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Woody Suwalski <terraluna977@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Ed Tomlinson <edt@aei.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>
	<2619529.mEMJol0YfM@grover>	<1549585.kmUPduLgev@grover>
	<10435496.M4aSBzoVye@grover>
	<CA+55aFwbOQCcd1qsW0rA+bQxN2Vgm9x832ZKmB7fndFX7DBE3w@mail.gmail.com>
 <CAPM=9tyHwYJ4CTFPZD4zLNFQyct8A_UmoyUMgR_bBZR5bJB+Pw@mail.gmail.com>
 <5358325D.6010409@gmail.com>
In-Reply-To: <5358325D.6010409@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.254]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(24454002)(51914003)(51704005)(199002)(189002)(23676002)(80976001)(83506001)(19580395003)(81342001)(99396002)(86362001)(77982001)(46102001)(50466002)(33656001)(59896001)(92726001)(92566001)(85202002)(97736001)(4396001)(85182001)(83072002)(19580405001)(65956001)(76482001)(54356999)(83322001)(44976005)(76176999)(87266999)(77096999)(50986999)(65816999)(74662001)(36756003)(85852003)(81542001)(20776003)(47776003)(2009001)(87936001)(74502001)(31966008)(79102001)(80022001)(65806001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB115;H:atltwp01.amd.com;FPR:B6BAF11E.8DD2B741.70C19D7B.40D8DF48.20317;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 01917B1794
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.04.2014 23:36, schrieb Woody Suwalski:
> Dave Airlie wrote:
>> On Wed, Apr 23, 2014 at 1:59 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> Dave, mind sending me a pull request for drm fixes?
>>>
>>> There's now at least these two:
>>>
>>>   - "drm/radeon/aux: fix hpd assignment for aux bus"
>>>   - "drm/radeon: use fixed PPL ref divider if needed"
>>>
>>> that look like fairly fatal regressions when they affect somebody.
>>>
>>> The fact that we already had *two* independent bugs be reported within
>>> days of that last out-of-merge-window pull request makes me very
>>> unhappy with the state of drm pulls.
>>>
>>> So please make sure that future fixes really are *fixes*. For
>>> regressions only. No more games like this.
>> The pll fallout is fixes for the initial feature that was in the 
>> merge window,
>> Tuning plls for monitors is always a pain in the ass, the previous 
>> algorithm
>> took a couple of kernels a few years back to get where it was, 
>> unfortunately
>> HDMI came along and showed up a bunch of its shortcomings. I'm happy
>> Alex and Christian are on top of things in terms of tracking regressions
>> and making sure they get fixed,
>>
>> the AUX fix yes I'm a bit pissed off about myself, but I missed a pull
>> from a few
>> weeks ago, felt guilty, and maybe should have chosen the other path 
>> and let it
>> wait a merge,
>>
>> Christian just sent me a -fixes pull with all of these in it and I'll
>> send it on to you
>> in a few mins.
>>
>> Dave.
>>
> That patch also fixes a shimmering (water floating) issue on Radeon 
> RV635 (Thinkpad T500)
> 1002:9591

Was this a long outstanding bug or a regression introduced with one of 
the recent patches?

Thanks for the info,
Christian.
