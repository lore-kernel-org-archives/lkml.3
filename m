Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036Ab3DNJbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 05:31:21 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:58982 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3DNJbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 05:31:19 -0400
Message-ID: <516A7760.7030907@kernel.org>
Date: Sun, 14 Apr 2013 12:31:12 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>
Subject: Re: [PATCH] x86: Add a Kconfig shortcut for a kvm-bootable kernel
References: <20130412181956.GA13099@pd.tnic>
In-Reply-To: <20130412181956.GA13099@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 4/12/13 9:19 PM, Borislav Petkov wrote:
> so I'm currently experimenting with my randconfig build scripts and
> thought that maybe it would be a cool thing to not only do the random
> builds only but also boot-test them in kvm. Which reminded me that we
> have that KVMTOOL_TEST_ENABLE config option in the kvmtool with which we
> can select all the stuff needed to boot the kernel in kvm.
>
> So I copied it. I now have an all.config in the repo with
> CONFIG_KVM_TEST_ENABLE=y in it so that the random builds can have the
> required support.
>
> So what do people think?
>
> It is pretty helpful for such testing; AFAICT Fengguang is doing his
> testing with kvm so he probably could use it too. And regardless, there
> are more and more reasons to boot the kernel in kvm so having a single
> option which selects the needed support makes more sense with time.
>
> And I haven't picked up the 'make kvmconfig' functionality because it
> is not strictly needed (yet) but it wouldn't hurt if we took it because
> someone has a good reason for needing it.

I obviously support having something like this in mainline. I wonder 
though if we could just call this "default standalone KVM guest config" 
instead of emphasizing testing angle.

			Pekka
