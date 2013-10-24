Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3JXHlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:41:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:54107 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3JXHlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:41:19 -0400
X-Spam-Score: -100.8
Message-ID: <5268CEDE.2080807@asianux.com>
Date: Thu, 24 Oct 2013 15:40:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Joern Rennecke <joern.rennecke@embecosm.com>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Takashi Iwai <tiwai@suse.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: Re: [PATCH] kernel/modsign_certificate.S: use real contents instead
 of macro GLOBAL()
References: <523FD9E7.3050303@asianux.com> <523FDBD7.4040602@asianux.com> <C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com> <523FE578.5060801@asianux.com> <52672DAC.1030307@asianux.com> <CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com> <52673E41.6040606@asianux.com> <5267AF98.1010800@asianux.com> <5268B0B1.9050009@asianux.com> <CAFLxGvzERDqwZhb_5d=bXKmqz6-Yrema_TLMTM7rjyeFeDJG_w@mail.gmail.com> <5268BD96.2060806@asianux.com> <5268C1D1.1020501@nod.at>
In-Reply-To: <5268C1D1.1020501@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 02:44 PM, Richard Weinberger wrote:
> Am 24.10.2013 08:26, schrieb Chen Gang:
>> On 10/24/2013 02:03 PM, Richard Weinberger wrote:
>> Anyway, maybe it is also the tool chain's bug (so I include related arc
>> tool chain guys in this mail).
> 
> That's exactly my point. Before you blindly patch the kernel just to make it
> somehow build you need to find the root cause.
> Do you even have an ARC board to test the kernel?
> 

Hmm... I don't think it is blindly, at least, we can not say: "if tool
chain has issues, we should not use it, if we have no related hard
wares, it is useless to compile them".

We are focus on the contribution, not on whether others have issues or
'qualifications', if we are sure this patch should be useful, we need go
ahead.

For normal members, it is not quite important, but for managerial
members or a company, of cause, they will/should understand these rules.


> Thanks,
> //richard
> 
> 
> 

Thanks.
-- 
Chen Gang
