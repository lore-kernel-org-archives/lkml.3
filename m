Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaCDXvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:51:00 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:59563 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754105AbaCDXu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:50:58 -0500
Date: Tue, 4 Mar 2014 23:50:44 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Graeme Gregory <graeme@xora.org.uk>
Cc: "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add maintainers for arm64 acpi
Message-ID: <20140304235044.GB11418@arm.com>
References: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>
 <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
 <20140304102316.GG30596@arm.com>
 <20140304190318.GE28736@xora-yoga13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304190318.GE28736@xora-yoga13>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 07:03:18PM +0000, Graeme Gregory wrote:
> On Tue, Mar 04, 2014 at 10:23:16AM +0000, Catalin Marinas wrote:
> > On Tue, Mar 04, 2014 at 02:15:45AM +0000, Graeme Gregory wrote:
> > > +ACPI ARM64
> > 
> > That's a pretty broad statement for a single file. Is it core support,
> > architected peripherals, SoC?
> > 
> Hi Catalin would changing the title to ACPI ARM64 Core Support be better
> in your mind. I do intend for the maintainership to cover just the
> plat/arm-core.c file.

See my reply to Grant. If that's the only thing you guys are aiming for,
who's in charge of the other bits? Face-to-face meeting in 3 hours
anyway, so we can get back here with the conclusion.

-- 
Catalin
