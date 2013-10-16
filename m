Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613Ab3JPTJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:09:51 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43971 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934569Ab3JPTJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <20131016190431.GA552@ulmo.nvidia.com>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
	<1381949500-501-3-git-send-email-treding@nvidia.com>
	<525EE1BC.3050605@arm.com>
	<CAMJs5B85FwnXN3YE5-KagSjYDH0aSeVYgcwvSXy8=LGfw=STaw@mail.gmail.com>
	<20131016190431.GA552@ulmo.nvidia.com>
Date: Wed, 16 Oct 2013 12:09:48 -0700
Message-ID: <CAMJs5B-v9gC_Rk6V63K+ge4mK388igqA7oQx8oYM=WaVXLd-EQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2013 12:04, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Wed, Oct 16, 2013 at 12:02:08PM -0700, Christoffer Dall wrote:
>> On 16 October 2013 11:58, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> > On 16/10/13 19:51, Thierry Reding wrote:
>> >> Today's linux-next merge of the kvm-arm tree got conflicts in
>> >>
>> >>       arch/arm/kvm/reset.c
>> >>
>> >> caused by commits e8c2d99 (KVM: ARM: Add support for Cortex-A7) and ac570e0
>> >> (ARM: kvm: rename cpu_reset to avoid name clash).
>> >>
>> >> I've fixed them up (see below). Please verify that the resolution looks
>> >> good.
>> >
>> > Looks good to me (I have the same resolution in my own tree).
>> >
>> Yes, fix is good.
>>
>> This will stay a conflict until kvm/next and kvm/fixes merge, which
>> doesn't happen before after the merge window, usually.  If that's
>> going to cause too many headaches, maybe we need to talk to the KVM
>> guys (cc'ed) about a solution until then.
>
> It shouldn't be a problem. Mark and I share the rerere cache, so unless
> the conflict changes somehow it'll get resolved automatically in future
> merges.
>
Cool, I had no idea how you dealt with these merges, but I figured a
daily manual operation was probably not how it works:)
