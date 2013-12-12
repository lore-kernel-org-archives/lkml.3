Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3LLLqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:46:52 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33808 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab3LLLqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:46:51 -0500
Date: Thu, 12 Dec 2013 11:46:10 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vinayak Kale <vkale@apm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Tuan Phan <tphan@apm.com>
Subject: Re: [PATCH V7 2/2] arm64: perf: add support for percpu pmu interrupt
Message-ID: <20131212114610.GA23971@mudshark.cambridge.arm.com>
References: <1386151791-4881-1-git-send-email-vkale@apm.com>
 <1386151791-4881-3-git-send-email-vkale@apm.com>
 <20131209165003.GJ13908@mudshark.cambridge.arm.com>
 <CAPrCYkfS9h_yoQMcrQDXpW_3FcSfiPz0aeNX+_gc=G4exSEVWg@mail.gmail.com>
 <CAPrCYkct6XePhYEEC=x0yNQoS-z=fcp2_WKxU1Zk0eO=9+ZaLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPrCYkct6XePhYEEC=x0yNQoS-z=fcp2_WKxU1Zk0eO=9+ZaLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 06:33:59AM +0000, Vinayak Kale wrote:
> > Below fixup works fine on APM platform.
> > Do you want me to send this fixup as part of next revision of the
> > patch or will you apply it yourself? (For later case, you have my ack)
> 
> Any comments? Do I need to send the fix-up in next revision of patch?

Looks fine to me; I've folded in my changes and applied it to my aarch64
branch. I'll queue it for 3.14 when Catalin and I start putting that
together.

Will
