Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaKYQUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:20:04 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63141 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaKYQUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:20:01 -0500
MIME-Version: 1.0
In-Reply-To: <1416931805-23223-3-git-send-email-alex.bennee@linaro.org>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-3-git-send-email-alex.bennee@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 25 Nov 2014 16:19:39 +0000
Message-ID: <CAFEAcA9P6aX+mh3rEMy=Z7SKF=kRrxgYefLwFcrk806QQpwiuQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Bharat Bhushan <r65777@freescale.com>, bp@suse.de,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2014 at 16:10, Alex Bennée <alex.bennee@linaro.org> wrote:
> +/* Exit types which define why we did a debug exit */
> +#define KVM_DEBUG_EXIT_ERROR           0x0
> +#define KVM_DEBUG_EXIT_SINGLE_STEP     0x1
> +#define KVM_DEBUG_EXIT_SW_BKPT         0x2
> +#define KVM_DEBUG_EXIT_HW_BKPT         0x3
> +#define KVM_DEBUG_EXIT_HW_WTPT         0x4

The names of these imply that they're generic, but they're
defined in an arch-specific header file...

-- PMM
