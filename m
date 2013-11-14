Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3KNAG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 19:06:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58271 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab3KNAGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 19:06:20 -0500
Message-ID: <528413DE.1090203@zytor.com>
Date: Wed, 13 Nov 2013 16:05:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: jerry.hoemann@hp.com
CC: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        matt.fleming@intel.com, yinghai@kernel.org, penberg@kernel.org,
        akpm@linux-foundation.org, linux-doc@vger.kernel.org,
        linux-efi@vger.kernel.org, vgoyal@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Early use of boot service memory
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com> <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com> <20131113224503.GB25344@anatevka.fc.hp.com> <52840206.5020006@zytor.com> <20131113235708.GC25344@anatevka.fc.hp.com>
In-Reply-To: <20131113235708.GC25344@anatevka.fc.hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 03:57 PM, jerry.hoemann@hp.com wrote:
> 
> I think i can go to a date based black list, that removes the manual
> step.  System running firmware before certain date assumes we need
> to do the work around.  If firmware is newer than that date, we don't
> use the workaround.  Blacklist overrides and allows current behavior
> for new firmware that is subsequently found to be broken and for
> which we can't convenience the manufacturer to fix.
> 

No, we can't, at least not for now.  We are continually finding new
platforms with the bug.

> 
> I will still point out that as currently used, efi_reserve_boot_services
> is wrong.  A work around for firmware bugs on one platform shouldn't be
> breaking platforms that don't have that bug.  Its just much less likely
> to cause problems with higher crash kernel allocation.
> 

It is wrong, yes, but it seems like a ubiquitous problem.

	-hpa


