Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaBSQiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:38:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51751 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754170AbaBSQiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:38:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Lan Tianyu <tianyu.lan@intel.com>, Joe Perches <joe@perches.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [PATCH v5 2/5] ACPI / processor_core: Rework _PDC related stuff to make it more arch-independent
Date: Wed, 19 Feb 2014 17:52:53 +0100
Message-ID: <1643739.gIWxXCQHpB@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <530413F0.4050008@linaro.org>
References: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org> <3459962.GkY99aHQbc@vostro.rjw.lan> <530413F0.4050008@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 19, 2014 10:16:16 AM Hanjun Guo wrote:
> On 2014年02月19日 08:50, Rafael J. Wysocki wrote:
> > On Wednesday, February 19, 2014 12:23:55 AM Hanjun Guo wrote:
> >> _PDC related stuff in processor_core.c is little bit X86/IA64 dependent,
> >> rework the code to make it more arch-independent, no functional change
> >> in this patch.
> >>
> >> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> >> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> > I've queued up patches [1,3-5/5] from this series for 3.15 (modulo changelog
> > modifications), but this one should be CCed to the x86 and ia64 maintainers.
> 
> Thanks! I will resend this patch with Tony and Thomas in cc list, so is 
> there any chance for this
> patch to be merged into 3.15 if I get acked from them?

If they ack it, then yes, it can.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
