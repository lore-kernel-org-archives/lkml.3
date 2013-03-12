Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab3CLLo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:44:59 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:62917 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab3CLLo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130312113048.GS4977@n2100.arm.linux.org.uk>
References: <1362663356-21151-1-git-send-email-tom.leiming@gmail.com>
	<CACVXFVOhr222CVrzkVP_oLgVkdReD9BXXSBg7fmp6Wvx9_peCw@mail.gmail.com>
	<20130312105638.GQ4977@n2100.arm.linux.org.uk>
	<CACVXFVOEvvFT805TJHoppqGRLTRuP18=Wg72LSXryffZD_WH1A@mail.gmail.com>
	<20130312113048.GS4977@n2100.arm.linux.org.uk>
Date: Tue, 12 Mar 2013 19:44:55 +0800
Message-ID: <CACVXFVP4NeZBg5yZW8q+vhgs0m3knkkdvyjv_hc9BLrFPqEBJA@mail.gmail.com>
Subject: Re: [PATCH v1] ARM: keep __my_cpu_offset consistent with generic one
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 7:30 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>>
>> Ingo and Peter, what is your opinion on the problem?
>
> Having discussed this with Ben Herrenschmidt, it seems that we do need
> to have a more complex patch to sort this out - we need to setup our
> private pointer inside setup_per_cpu_areas().

Suppose so, seems the patch is still needed to make CPU0 see
static variables in '.data..percpu' section correctly.


Thanks,
-- 
Ming Lei
