Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaIXJpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:45:25 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37724 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaIXJpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:45:21 -0400
Message-ID: <542292A7.6000600@redhat.com>
Date: Wed, 24 Sep 2014 11:45:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Gleb Natapov <gleb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Will Deacon <will.deacon@arm.com>,
        Alex Williamson <Alex.Williamson@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [next-20140923] KVM: Remove KVM_VFIO
References: <1411499391.24045.13.camel@x220> <5421D82E.6090103@redhat.com> <1411546927.19525.12.camel@x220>
In-Reply-To: <1411546927.19525.12.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/09/2014 10:22, Paul Bolle ha scritto:
> There are no checks for CONFIG_KVM_VFIO and nothing depends on KVM_VFIO.
> Setting KVM_VFIO has no effect. Remove that Kconfig symbol.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> I choose not to mention commit 80ce1639727e ("KVM: VFIO: register
> kvm_device_ops dynamically") as references to linux-next commits might
> go stale and only confuse future readers.

In the case of KVM, linux-commit hashes are substantially stable.  I'll
add back the reference.

Thanks for the patch, I'll apply it.

Paolo
