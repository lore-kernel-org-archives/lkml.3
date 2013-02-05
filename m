Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3BEMYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:24:38 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:50137 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3BEMYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:24:36 -0500
Date: Tue, 5 Feb 2013 13:24:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Stoney Wang <song-bo.wang@hp.com>, stable@kernel.org
Subject: Re: [PATCH] x86, apic: Check fadt x2apic phys in x2apic_phys_probe()
Message-ID: <20130205122432.GE21455@gmail.com>
References: <20130204110304.GD24173@gmail.com>
 <1360009767-3633-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360009767-3633-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> From: Stoney Wang <song-bo.wang@hp.com>
> 
> When HP ProLiant DL980 G7 Server boot without x2apic_phys, there will be
> intermittent lost interrupts and could result in a hang or data loss.

What does 'boot without x2apic_phys' mean?

Does it mean x2apic_phys=0 boot command line? Or, because 
x2apic_phys is off by default, does it simply mean that if it's 
booted with a default kernel, without any workaround specified 
on the boot command line?

Thanks,

	Ingo
