Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaIXMHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaIXMHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:07:47 -0400
Message-ID: <5422B409.5000808@redhat.com>
Date: Wed, 24 Sep 2014 14:07:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>,
        Alex Williamson <Alex.Williamson@redhat.com>
Subject: Re: [PATCH v2] kvm-vfio: do not use module_init
References: <1411559780-12676-1-git-send-email-pbonzini@redhat.com> <20140924120505.GF28823@arm.com>
In-Reply-To: <20140924120505.GF28823@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/09/2014 14:05, Will Deacon ha scritto:
>> > +#ifdef CONFIG_KVM_VFIO
>> > +#include "vfio.h"
>> > +#endif
> Can't you include this unconditionally, then have the #ifdef in the header
> and a static inline kvm_vfio_ops_init that returns 0?

Yup.  What was I thinking...

Paolo
