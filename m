Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaKSJaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:30:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaKSJaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:30:00 -0500
Message-ID: <546C6310.305@redhat.com>
Date: Wed, 19 Nov 2014 10:29:52 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, gleb@kernel.org
CC: mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Fix Mes in emulate.c
References: <546C0BB6.5010109@gmail.com>
In-Reply-To: <546C0BB6.5010109@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/11/2014 04:17, nick wrote:
> Greeting Gleb and other maintainers, I known this may not be that
> easy to fix but if someone is willing to send me the fault addresses
> or a hardware manual in order to fix and add the correct return
> correct addresses for the fix mes in the emulate.c for the x86
> architecture.

Hi Nick,

I need to check more closely, but I think the FIXMEs have already been
fixed.  The address is already stored by arch/x86/kvm/paging_tmpl.h's
FNAME(walk_addr_generic) in walker->fault.address, and propagated by
FNAME(gva_to_gpa).

You can send a patch to remove them.

Paolo
