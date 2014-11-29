Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaK2QUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:20:19 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:43736 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaK2QUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:20:15 -0500
Date: Sat, 29 Nov 2014 17:20:53 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Bharat Bhushan <r65777@freescale.com>, bp@suse.de,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
Message-ID: <20141129162053.GD23653@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-3-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA9P6aX+mh3rEMy=Z7SKF=kRrxgYefLwFcrk806QQpwiuQ@mail.gmail.com>
 <87ppcaknpx.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ppcaknpx.fsf@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 03:04:10PM +0000, Alex Bennée wrote:
> 
> Peter Maydell <peter.maydell@linaro.org> writes:
> 
> > On 25 November 2014 at 16:10, Alex Bennée <alex.bennee@linaro.org> wrote:
> >> +/* Exit types which define why we did a debug exit */
> >> +#define KVM_DEBUG_EXIT_ERROR           0x0
> >> +#define KVM_DEBUG_EXIT_SINGLE_STEP     0x1
> >> +#define KVM_DEBUG_EXIT_SW_BKPT         0x2
> >> +#define KVM_DEBUG_EXIT_HW_BKPT         0x3
> >> +#define KVM_DEBUG_EXIT_HW_WTPT         0x4
> >
> > The names of these imply that they're generic, but they're
> > defined in an arch-specific header file...
> 
> Yeah, I think these will die and I'll just export the syndrome
> information directly to QEMU.

huh?

-Christoffer
