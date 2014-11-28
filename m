Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaK1Qqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:46:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57222 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaK1Qqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:46:40 -0500
Date: Fri, 28 Nov 2014 17:46:37 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: tip-bot for Jiang Liu <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org, mingo@kernel.org,
        rdunlap@infradead.org, bhelgaas@google.com, hpa@zytor.com,
        tony.luck@intel.com, rjw@rjwysocki.net, grant.likely@linaro.org,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        yinghai@kernel.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jroedel@suse.de
Subject: Re: [tip:x86/apic] x86, irq: Use cached IOAPIC entry instead of
 reading from hardware
Message-ID: <20141128164637.GE30997@pd.tnic>
References: <1416901802-24211-30-git-send-email-jiang.liu@linux.intel.com>
 <tip-fda7c08b1349cc4c65f8a5240b10f7e9938604b8@git.kernel.org>
 <20141127193213.GB4190@pd.tnic>
 <5477DE90.5090500@linux.intel.com>
 <20141128113358.GB30997@pd.tnic>
 <20141128115306.GC30997@pd.tnic>
 <54789774.7030704@linux.intel.com>
 <54789DC1.7050003@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54789DC1.7050003@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 12:07:29AM +0800, Jiang Liu wrote:
>  With this patch applied, KVM with SMP kernel boots successfully now:)

Same with my laptop, thanks! :-)

Reported-and-tested-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
