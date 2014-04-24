Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaDXIV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:21:57 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:48487
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752572AbaDXIVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:21:51 -0400
X-WSS-ID: 0N4J0K8-08-EZ1-02
X-M-MSG: 
Message-ID: <5358C997.50803@amd.com>
Date: Thu, 24 Apr 2014 10:21:43 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>, Dave Airlie <airlied@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>
 <CA+55aFwbOQCcd1qsW0rA+bQxN2Vgm9x832ZKmB7fndFX7DBE3w@mail.gmail.com>
 <CAPM=9tyHwYJ4CTFPZD4zLNFQyct8A_UmoyUMgR_bBZR5bJB+Pw@mail.gmail.com>
 <2963840.VTDy2Dfbed@grover>
In-Reply-To: <2963840.VTDy2Dfbed@grover>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.254]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377454003)(24454002)(52604005)(199002)(189002)(41574002)(65816999)(87936001)(77096999)(76176999)(54356999)(50986999)(85182001)(85202002)(36756003)(4396001)(86362001)(33656001)(92726001)(81342001)(81542001)(50466002)(92566001)(83506001)(65806001)(74502001)(74662001)(31966008)(97736001)(85852003)(99396002)(19580395003)(44976005)(19580405001)(83322001)(23676002)(80976001)(2009001)(77982001)(65956001)(80022001)(83072002)(20776003)(47776003)(46102001)(76482001)(79102001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR02MB123;H:atltwp02.amd.com;FPR:86BAF11E.8CD29702.70C99D7B.40E4CF48.20355;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 01917B1794
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.04.2014 00:04, schrieb Ed Tomlinson:
> On Wednesday 23 April 2014 07:54:17 Dave Airlie wrote:
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
>> The pll fallout is fixes for the initial feature that was in the merge window,
>> Tuning plls for monitors is always a pain in the ass, the previous algorithm
>> took a couple of kernels a few years back to get where it was, unfortunately
>> HDMI came along and showed up a bunch of its shortcomings. I'm happy
>> Alex and Christian are on top of things in terms of tracking regressions
>> and making sure they get fixed,
>>
>> the AUX fix yes I'm a bit pissed off about myself, but I missed a pull
>> from a few
>> weeks ago, felt guilty, and maybe should have chosen the other path and let it
>> wait a merge,
>>
>> Christian just sent me a -fixes pull with all of these in it and I'll
>> send it on to you
>> in a few mins.
> Hi
>
> Given the fun I had with rc1 I decided to try this pull before rc2 and its working fine here.
>
> Thanks!

Thanks for testing.

As Dave noted PLLs can be quite painful to get right, so it's 
unfortunately not uncommon that fixing one issue uncovers other 
outstanding issues like in your case.

Please leave me a note if that should ever happen again,
Christian.

>
> Ed Tomlinson

