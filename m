Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3HTROd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:14:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39769 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3HTROc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:14:32 -0400
Message-ID: <5213A40C.6060509@arm.com>
Date: Tue, 20 Aug 2013 18:14:52 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 0/6] ARM/ARM64 architected timer updates
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
In-Reply-To: <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 17:14:28.0140 (UTC) FILETIME=[BA16CEC0:01CE9DC8]
X-MC-Unique: 113082018142900201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/13 18:29, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> This patch series adds support to configure the rate and enable the
> event stream for architected timer. The event streams can be used to
> impose a timeout on a WFE, to safeguard against any programming error
> in case an expected event is not generated or even to implement
> wfe-based timeouts for userspace locking implementations.
> 
> Since the timer control register is reset to zero on warm boot, CPU
> PM notifier is added to re-initialize it.
> 
> Changes v2->v3:
> 1. Moved ARM and ARM64 changes into separate patches
> 2. Added native hwcaps definations(ARM/ARM64) and compat-specific
>    definitions(ARM64) to the users for the event stream feature. 
> 
Hi Catalin,

Can you review this version of the series ?

Regards,
Sudeep


