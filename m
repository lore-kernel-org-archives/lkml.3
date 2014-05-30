Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367AbaE3UF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:05:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47367 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030351AbaE3UF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:57 -0400
Message-ID: <5388E499.6080101@zytor.com>
Date: Fri, 30 May 2014 13:05:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Marian Marinov <mm@1h.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
Subject: Re: Pondering per-process vsyscall disablement
References: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com> <537EB60E.40204@1h.com> <CALCETrWgtQCRiHt+am8+DoOMVvTuxy05AB6zzg3iAheGs13L6A@mail.gmail.com> <538658EE.8030809@zytor.com> <CALCETrUhZp+edRCx2SEzuJup0HWhV5WSiheCiZWuUjVueTJHfQ@mail.gmail.com>
In-Reply-To: <CALCETrUhZp+edRCx2SEzuJup0HWhV5WSiheCiZWuUjVueTJHfQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 01:00 PM, Andy Lutomirski wrote:
> 
> Do the flags go in the ELF loader or in the executable we're running?
> Or both (and, if both, do we and them or or them)?
> 
> I think the interpreter makes a little more sense in general: for the
> most part, use of vsyscalls is a property of the runtime environment,
> not of the program being run.  But maybe this is naive.
> 

They go into each object which becomes part of the running program, i.e.
executable, dynamic libraries, and dynamic linker.

	-hpa


