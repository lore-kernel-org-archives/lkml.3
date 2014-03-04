Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaCDRH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 12:07:56 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41113 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaCDRHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 12:07:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140304111520.GE8766@mudshark.cambridge.arm.com>
References: <1393899345-7397-1-git-send-email-graeme.gregory@linaro.org>
 <1393899345-7397-2-git-send-email-graeme.gregory@linaro.org>
 <1393899715.20435.8.camel@joe-AO722> <53153A4C.9050602@infradead.org>
 <CACxGe6tD3mQshDSoEQaPXAnXG_siUdiFoAWhjmO2gDY7ZzkjUw@mail.gmail.com> <20140304111520.GE8766@mudshark.cambridge.arm.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Wed, 5 Mar 2014 01:07:34 +0800
X-Google-Sender-Auth: CvoL3pSDqXl9jhCm8WbR8MMG4pM
Message-ID: <CACxGe6svyLHZO8k6qVs+hhyAWxeg3tzh1wUfbRB_z-sxRMv4qw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add maintainers for arm64 acpi
To: Will Deacon <will.deacon@arm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Joe Perches <joe@perches.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 7:15 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Mar 04, 2014 at 10:59:46AM +0000, Grant Likely wrote:
>> I agree with merging it with the rest of the series, but comparing it
>> to a blank cheque is not appropriate. Merely having an entry in
>> MAINTAINERS doesn't immediately confer trust or ability to merge code,
>> but it does tell people who to talk to when looking at ACPI on ARM.
>> You can bet that neither Linus, Len or Rafael will merge ARM ACPI
>> trees from them if you disagree. (And even if they did, you would
>> yell, and Linus would revert it).
>
> If you want to know who to talk to regarding a subsystem then you use
> get_maintainer.pl and/or git blame. Regardless of this patch, neither of
> those tools will identify Graeme or Hanjun as the contacts for ACPI on ARM.
>
> I think we're in agreement, but just to spell it out: this patch should be
> included at the end of a series adding the files which will be maintained.

Yes, agreed.

g.
