Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaBSCQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:16:24 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38049 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBSCQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:16:22 -0500
Message-ID: <530413F0.4050008@linaro.org>
Date: Wed, 19 Feb 2014 10:16:16 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lan Tianyu <tianyu.lan@intel.com>, Joe Perches <joe@perches.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [PATCH v5 2/5] ACPI / processor_core: Rework _PDC related stuff
 to make it more arch-independent
References: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org> <1392740638-2479-3-git-send-email-hanjun.guo@linaro.org> <3459962.GkY99aHQbc@vostro.rjw.lan>
In-Reply-To: <3459962.GkY99aHQbc@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年02月19日 08:50, Rafael J. Wysocki wrote:
> On Wednesday, February 19, 2014 12:23:55 AM Hanjun Guo wrote:
>> _PDC related stuff in processor_core.c is little bit X86/IA64 dependent,
>> rework the code to make it more arch-independent, no functional change
>> in this patch.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> I've queued up patches [1,3-5/5] from this series for 3.15 (modulo changelog
> modifications), but this one should be CCed to the x86 and ia64 maintainers.

Thanks! I will resend this patch with Tony and Thomas in cc list, so is 
there any chance for this
patch to be merged into 3.15 if I get acked from them?

Best regards
Hanjun
