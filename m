Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3EaMaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:30:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35689 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab3EaMaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:30:09 -0400
Date: Fri, 31 May 2013 14:30:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@kernel.org>, Russ Anderson <rja@sgi.com>,
        joeyli <jlee@suse.com>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130531123015.GC17843@nazgul.tnic>
References: <20130524074331.GL14575@console-pimps.org>
 <20130529210115.GC28027@sgi.com>
 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
 <20130529224645.GA16582@sgi.com>
 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com>
 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 01:06:09PM +0200, Jiri Kosina wrote:
> (*) If one would be naive enough, he'd believe that the pressure
> should be put on the BIOS writers instead of OS to fix the bug :)

Oh, definitely pressure on BIOS dudes. If they're in violation of the
spec and they still can fix it in time, they better. I'm sick and tired
of having to deal with BIOS idiocy in kernel code.
