Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab3FRR6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:58:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54835 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab3FRR6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:58:05 -0400
Message-ID: <51C09FAF.3050207@arm.com>
Date: Tue, 18 Jun 2013 18:58:07 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH 3/4] ARM/ARM64: arch_timer: remove __cpuinit attribute
 for arch_counter_set_user_access
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1371575223-21702-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1371575223-21702-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 18 Jun 2013 17:58:00.0354 (UTC) FILETIME=[5F10C820:01CE6C4D]
X-MC-Unique: 113061818580209801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/13 18:07, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> We must not declare arch_counter_set_user_access as __cpuinit as we
> need to use it in warm reset paths like CPU PM notifiers.
> 
This patch should be dropped as __cpuinit is removed completely by
http://www.spinics.net/lists/arm-kernel/msg252410.html
Just happen to see it now.

Regards,
Sudeep



