Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaBXTQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:16:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40050 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbaBXTQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:16:22 -0500
Message-ID: <530B9A54.5060502@zytor.com>
Date: Mon, 24 Feb 2014 11:15:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Vince Weaver <vincent.weaver@maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <53084317.4090304@zytor.com>	<alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu>	<e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com>	<alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu>	<alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu>	<530AD71E.50800@zytor.com>	<alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu>	<alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>	<18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com>	<alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu>	<20140224172536.GD9987@twins.programming.kicks-ass.net>	<alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>	<530B841F.5050803@zytor.com>	<alpine.DEB.2.10.1402241258590.20170@vincent-weaver-1.um.maine.edu>	<alpine.DEB.2.10.1402241302210.20560@vincent-weaver-1.um.maine.edu>	<530B90A5.3090302@zytor.com> <20140224141329.1cd3bb52@gandalf.local.home>
In-Reply-To: <20140224141329.1cd3bb52@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 11:13 AM, Steven Rostedt wrote:
>>
>> Either way, it really seems like we have a case of CR2 leakage out of
>> the NMI context.
> 
> Ah, and x86_64 saves off the cr2 register when entering NMI and restores
> it before returning. But it seems to be missing from the i386 code.
> 

OK, that might be a problem, but this is the 64-bit kernel.

	-hpa


