Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3FOWVy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 18:21:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39874 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab3FOWVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 18:21:52 -0400
Message-ID: <51BCE8BF.5080008@zytor.com>
Date: Sat, 15 Jun 2013 15:20:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>, Cliff Wickman <cpw@sgi.com>,
        "Alex Shi" <alex.shi@intel.com>, Sasha Levin <levinsasha928@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: Re: [PATCH v15 0/4] trace,x86: irq vector tracepoint support
References: <51B2472B.9040909@hds.com> <A5ED84D3BB3A384992CBB9C77DEDA4D41B03B6CC@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41B03B6CC@USINDEM103.corp.hds.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 08:47 AM, Seiji Aguchi wrote:
> Any comments?

This patchset breaks building with SGI UV support enabled:

/home/hpa/kernel/distwork/arch/x86/platform/uv/tlb_uv.c: In function
‘uv_bau_init’:
/home/hpa/kernel/distwork/arch/x86/platform/uv/tlb_uv.c:2130:1: error:
‘trace_uv_bau_message_intr1’ undeclared (first
use in this function)
/home/hpa/kernel/distwork/arch/x86/platform/uv/tlb_uv.c:2130:1: note:
each undeclared identifier is reported only once
 for each function it appears in


