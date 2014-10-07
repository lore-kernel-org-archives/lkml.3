Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaJGT15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:27:57 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:41943 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaJGT1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:27:55 -0400
Message-ID: <54343EB4.30708@imgtec.com>
Date: Tue, 7 Oct 2014 12:27:48 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>
CC: Andy Lutomirski <luto@amacapital.net>,
        Matthew Fortune <Matthew.Fortune@imgtec.com>,
        David Daney <david.s.daney@gmail.com>,
        "David Daney" <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx> <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx> <54337127.40806@gmail.com> <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org> <543431DA.4090809@imgtec.com> <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com> <20141007190943.GM23797@brightrain.aerifal.cx> <54343C2B.2080801@imgtec.com> <20141007192107.GN23797@brightrain.aerifal.cx>
In-Reply-To: <20141007192107.GN23797@brightrain.aerifal.cx>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 12:21 PM, Rich Felker wrote:
> The in-stack trampoline support could be left but used only for 
> emulating instructions the kernel doesn't know. This would make all 
> normal binaries immediately usable with non-executable stack, and 
> would avoid the only potential source of regressions. Ultimately I 
> think the "xol" stuff should be removed, but that could be a long term 
> goal. 
Thank you, it is exactly what I am doing in patch series named "[PATCH 
0/3] MIPS executable stack protection".
I just setup a special stack for that.
