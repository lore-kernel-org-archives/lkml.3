Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbaGSV5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 17:57:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32150 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751370AbaGSV47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 17:56:59 -0400
Date: Sat, 19 Jul 2014 17:56:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] ARM: add IPI tracepoints
Message-ID: <20140719175655.249601bf@gandalf.local.home>
In-Reply-To: <CAKv+Gu-RZ4s+33LVOK3eTrvb3ig0YXmNwT0-3GS2-WuvThyXTg@mail.gmail.com>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org>
	<1405660735-13408-3-git-send-email-nicolas.pitre@linaro.org>
	<20140718160418.54d11f6a@gandalf.local.home>
	<alpine.LFD.2.11.1407181652080.3647@knanqh.ubzr>
	<20140718172221.6dbe83e4@gandalf.local.home>
	<CAKv+Gu_71vJFf3aUZso1X7m7fULUMhxj+MZVYq+LGNRLJvGyAA@mail.gmail.com>
	<20140719162810.02285fc8@gandalf.local.home>
	<CAKv+Gu-RZ4s+33LVOK3eTrvb3ig0YXmNwT0-3GS2-WuvThyXTg@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2014 22:50:16 +0200
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

 
> OK, so if the general case has been fixed, perhaps we should ask Paul
> to drop my patch?
> 

No, for a few reasons. One, this patch still needs to get in to fix the
problem for RCU. Two, RCU basically open codes the creation of the
string, thus this wont solve it for RCU.

-- Steve
