Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813Ab3EBV62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:58:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab3EBV61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:58:27 -0400
Subject: Re: [PATCH] KVM: allow host header to be included even for !CONFIG_KVM
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20130402115612.GB3889@redhat.com>
Date: Thu, 2 May 2013 23:58:19 +0200
Cc: Kevin Hilman <khilman@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, linaro-kernel@lists.linaro.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <A7C27212-7BF2-4976-AB41-B74D8311EA3B@suse.de>
References: <1363823921.25034.35@snotra> <20130321072955.GO3889@redhat.com> <87ppyshlq5.fsf@linaro.org> <1363891354.31522.17@snotra> <20130321191600.GG9382@redhat.com> <1363894393.31522.20@snotra> <20130321211736.GI9382@redhat.com> <CAFTL4hz2=VJBLG1w31JSPDtRdobcmL5oY6XkR46vi3zS904VGA@mail.gmail.com> <20130324140114.GV3889@redhat.com> <87txnz9o7n.fsf@linaro.org> <20130402115612.GB3889@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02.04.2013, at 13:56, Gleb Natapov wrote:

> On Mon, Mar 25, 2013 at 02:14:20PM -0700, Kevin Hilman wrote:
>> Gleb Natapov <gleb@redhat.com> writes:
>> 
>>> On Sun, Mar 24, 2013 at 02:44:26PM +0100, Frederic Weisbecker wrote:
>>>> 2013/3/21 Gleb Natapov <gleb@redhat.com>:
>>>>> Isn't is simpler for kernel/context_tracking.c to define empty
>>>>> __guest_enter()/__guest_exit() if !CONFIG_KVM.
>>>> 
>>>> That doesn't look right. Off-cases are usually handled from the
>>>> headers, right? So that we avoid iffdeffery ugliness in core code.
>>> Lets put it in linux/context_tracking.h header then.
>> 
>> Here's a version to do that.
>> 
> Frederic, are you OK with this version?

Did anything happen on this? The tree is still broken...


Alex

