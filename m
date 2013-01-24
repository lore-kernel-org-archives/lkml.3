Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab3AXRdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:33:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37477 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab3AXRdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:33:05 -0500
Date: Thu, 24 Jan 2013 18:35:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, JBeulich@suse.com
Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Message-ID: <20130124173555.GJ13463@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
	devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
	jasowang@redhat.com, tglx@linutronix.de, JBeulich@suse.com
References: <1358992569-22826-1-git-send-email-kys@microsoft.com>
 <20130124092821.GA13463@pd.tnic>
 <04854149-91a3-4834-b2bb-de301c8241c9@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <04854149-91a3-4834-b2bb-de301c8241c9@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 06:11:32AM -0600, H. Peter Anvin wrote:
> Sounds great in theory at least, as long as it doesn't mean pushing a
> bunch of #ifdefs into other code.

Just one set in hypervisor.h but this is the RightWay™ we do it in the
kernel :-).

Anyway, it turned out to be easier than I thought, just two patches
which I'll be sending as a reply to this message. I'll run more
randconfig tests on them, anyone sees issues please let me know.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
