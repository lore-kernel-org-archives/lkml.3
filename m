Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbbATKjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:39:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717AbbATKjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:39:11 -0500
Message-ID: <54BE3044.6050404@redhat.com>
Date: Tue, 20 Jan 2015 11:39:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Li Kaihang <li.kaihang@zte.com.cn>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject
 directly bug with guestos RFLAGS.IF=0
References: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn> <54BD22CB.902@redhat.com> <OFA79F49F0.447F9773-ON48257DD3.00086E68-48257DD3.0039B508@zte.com.cn>
In-Reply-To: <OFA79F49F0.447F9773-ON48257DD3.00086E68-48257DD3.0039B508@zte.com.cn>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20/01/2015 11:34, Li Kaihang wrote:
> Li kaihang: I think I make a mistake here that IDT-vectoring information field is not written by vectored event but is done by Event Delivery.
>             vm exit during Event Delivery is not triggered by external interrupt delivery, only vm exit due to vectored event is done so.
>             Both are completely different, and you are right. I'm very sorry this patch is wrong.

No problem!

Paolo
