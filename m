Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaAVELF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 23:11:05 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40869 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaAVEK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 23:10:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
References: <CAJZOPZ+4yQ-sT=ks7+eiJjkxOjy5w=BmG16JVcUPiuVsof7qEA@mail.gmail.com>
	<CAG4TOxOMmvFWnkU3DBn33rscEKh2_YfbUCKY=iY8PCVN3+nEsA@mail.gmail.com>
	<52CD1C68.4050406@mellanox.com>
	<1389645171.5567.459.camel@haakon3.risingtidesystems.com>
	<1389820541.5567.543.camel@haakon3.risingtidesystems.com>
	<CAG4TOxNa32sLxifPx_f8sW04B_qSh01WWfWjRvam6fjvFLDXSQ@mail.gmail.com>
	<1389906852.5567.668.camel@haakon3.risingtidesystems.com>
	<CAG4TOxPeYQ=e5LdJft1Hkx8donUQjJaKDEAv3iRLGxPYJQ_b9w@mail.gmail.com>
	<1390102949.5567.749.camel@haakon3.risingtidesystems.com>
	<52DBB4F1.4020400@mellanox.com>
	<CAJZOPZJFbcTh2zO8mos0M+gv0LW-Gmh877Vxe4tLvfPX19oqTw@mail.gmail.com>
	<CAJZOPZLuz-Z59agBd0Q9J2=sSG-F+Y8MrJkoGbtiF5M+CnKU1g@mail.gmail.com>
	<CAG4TOxPLEfyWsUDf4_371u=_=tOgW2v5J4zSz8xx73DfziZOZg@mail.gmail.com>
Date: Wed, 22 Jan 2014 06:10:58 +0200
Message-ID: <CAJZOPZKciZ-hei10RGYGOqHvNDWe1awkkFwsB7Q1H3V+qU2c-A@mail.gmail.com>
Subject: Re: linux rdma 3.14 merge plans
From: Or Gerlitz <or.gerlitz@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hefty Sean <sean.hefty@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        target-devel <target-devel@vger.kernel.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 2:43 AM, Roland Dreier <roland@kernel.org> wrote:
> On Tue, Jan 21, 2014 at 2:00 PM, Or Gerlitz <or.gerlitz@gmail.com> wrote:
>> Roland, ping! the signature patches were posted > three months ago. We
>> deserve a response from the maintainer that goes beyond "I need to
>> think on that".
>>
>> Responsiveness was stated by Linus to be the #1 requirement from
>> kernel maintainers.
>
> Or, I'm not sure what response you're after from me.

Roland, what I am after is a r-e-s-p-o-n-s-e from you, and let it
contain what ever justified and/or unjustified mud as below. We posted
the V0 series on Oct 15 2013 and since that time not a word from you,
except for an "I need to think on that" comment last week after we
nudged million times.

You can't leave us clueless in the air for whole three months without
any concrete or unconcrete comment. There's no way to carry kernel
development like that. I am old enough to hear and face "no" and "wTF
is this" or "yTF you do it this way" etc etc, this happened few times
with e.g with networking patches we sent  and we either improved
things or did them differently or whatever needed to be done.

There's no way on earth to face plain ignoring of your work, and this
is what happens here. I had no way to get your below response except
for going to LKML, why?


> Linus has also said that maintainers should say "no" a lot more
> (http://lwn.net/Articles/571995/) so maybe you want me to say, "No, I
> won't merge this patch set, since it adds a bunch of complexity to
> support a feature no one really cares about."  Is that it?  (And yes I
> am skeptical about this stuff — I work at an enterprise storage
> company and even here it's hard to find anyone who cares about
> DIF/DIX, especially offload features that stop it from being
> end-to-end)
>
> I'm sure you're not expecting me to say, "Sure, I'll merge it without
> understanding the problem it's solving or how it's doing that,"
> especially given the your recent history of pushing me to merge stuff
> like the IP-RoCE patches back when they broke the userspace ABI.
>
> I'd really rather spend my time on something actually useful like
> cleaning up softroce.
>
>  - R.
