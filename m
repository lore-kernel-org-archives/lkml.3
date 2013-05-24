Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140Ab3EXIaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:30:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38844 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759985Ab3EXIaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:30:14 -0400
Date: Fri, 24 May 2013 10:29:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] x86/microcode: early microcode patch loading
 support on AMD
Message-ID: <20130524082948.GA23402@nazgul.tnic>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
 <3E5A0FA7E9CA944F9D5414FEC6C712205633D6C3@ORSMSX106.amr.corp.intel.com>
 <20130523212301.GA13275@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130523212301.GA13275@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 04:23:01PM -0500, Jacob Shin wrote:
> On Thu, May 23, 2013 at 09:01:21PM +0000, Yu, Fenghua wrote:
> > > From: Jacob Shin [mailto:jacob.shin@amd.com]
> > > The following patchset adds early microcode patch loading support on
> > > AMD systems, on top of the framework introduced by:
> > >   https://lkml.org/lkml/2012/12/21/193
> > > 
> > 
> > Could you please change Documentation/x86/early-microcode.txt for AMD? At least please add AMD microcode file in cpio name space: kernel/x86/microcode/AuthenticAMD.bin. Users can generate the cpio file with AMD microcode based on your document.
> 
> Ah, yes will do. I'll send out another revision tomorrow.

Jacob, would you please wait a bit longer when sending new revisions after
people have had time to review the current one first?

A couple of days is normally a good timeout. :)

Thanks.
