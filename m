Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab3LDOQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:16:49 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40622 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab3LDOQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:16:47 -0500
Message-ID: <529F3942.2020907@linaro.org>
Date: Wed, 04 Dec 2013 22:16:34 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [RFC part1 PATCH 3/7] ACPI / processor_core: Rework _PDC related
 stuff to make it more arch-independent
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <1386088611-2801-4-git-send-email-hanjun.guo@linaro.org> <20131203165140.24a05540@alan.etchedpixels.co.uk>
In-Reply-To: <20131203165140.24a05540@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月04日 00:51, One Thousand Gnomes wrote:
> On Wed,  4 Dec 2013 00:36:47 +0800
> Hanjun Guo <hanjun.guo@linaro.org> wrote:
>
>> _PDC related stuff in processor_core.c is little bit X86/IA64 dependent,
>> rework the code to make it more arch-independent.
>>
>> The return value of acpi_processor_eval_pdc() should be 'acpi_status' but
>> defined as 'int', fix it too.
> Why not just define boot_options_idle_override as well. Then you can
> leave the code unchanged. Also more importantly you can have override
> values for ARM when it turns out you need those too and the logic will be
> the same for both processor families

There is a platform dependent head file such as pdc_intel.h which contains
some macros, some of those macros are used in arch-independent file processor_core.c,
that's why I posted this patch.

Thanks
Hanjun

