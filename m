Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaHRMtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaHRMtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:49:31 -0400
Message-ID: <53F1F653.1030903@redhat.com>
Date: Mon, 18 Aug 2014 14:49:23 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: x86: #GP when attempts to write reserved bits
 of Variable Range MTRRs
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com> <1408355431-115633-5-git-send-email-wanpeng.li@linux.intel.com> <20140818122729.GA1001@kernel>
In-Reply-To: <20140818122729.GA1001@kernel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/08/2014 14:27, Wanpeng Li ha scritto:
> > Section 11.11.2.3 of the SDM mentions "All other bits in the IA32_MTRR_PHYSBASEn 
> > and IA32_MTRR_PHYSMASKn registers are reserved; the processor generates a 
> > general-protection exception(#GP) if software attempts to write to them". This 
> > patch do it in kvm.
>
> How about this one?

It's okay, but it is going to change after you modify patch 4.

Paolo
