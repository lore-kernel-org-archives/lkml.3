Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab3CIHZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 02:25:49 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:60440 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3CIHZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 02:25:47 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1303082108590.22263@ionos>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
	<1360351703-20571-3-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.02.1303082104580.22263@ionos>
	<alpine.LFD.2.02.1303082108590.22263@ionos>
Date: Fri, 8 Mar 2013 23:25:47 -0800
X-Google-Sender-Auth: zV4dCLBzOiWlAbCj-KQ3beuE9OY
Message-ID: <CAE9FiQVGN6ZheaYaj-tztNZpMZ9QN4X=kKu5_yX=bamV2b2FxA@mail.gmail.com>
Subject: Re: [PATCH v2 02/26] x86, irq: Modify irq chip once for irq remapping
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 12:10 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> And just for clarification. If you are not going to provide proper
> changelogs for _all_ patches of the series, this stuff is going
> directly towards /dev/null. I'm not wasting my time to review any of
> that otherwise.

ok, will try to update change logs and resend them next week.

Thanks

Yinghai
