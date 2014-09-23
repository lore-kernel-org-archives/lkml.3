Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaIWUnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:43:32 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59554 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbaIWUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:43:29 -0400
Date: Tue, 23 Sep 2014 21:43:26 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20140923204326.GK18635@console-pimps.org>
References: <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
 <20140923055802.GA29052@gmail.com>
 <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
 <20140923131805.GH18635@console-pimps.org>
 <CA+55aFyLrvrc2mv0oVPggQjXDVqA2ejZEufEPdMfbW=f_dOqmQ@mail.gmail.com>
 <20140923161117.GJ18635@console-pimps.org>
 <20140923161751.GB7858@hansolo.jdub.homelinux.org>
 <20140923172113.GC7858@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923172113.GC7858@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep, at 01:21:13PM, Josh Boyer wrote:
> 
> All of the machines that were broken and subsequently fixed by reverting
> the EFI GOT change still boot fine with this patch.  That includes the
> macbook and SB enabled machines.
> 
> So results as expected.  Thanks.

Great, thanks Josh.

I'm gonna queue up this revert to fix Maarten's boot issue, along with
the patch to drop the "setup_efi_pci() failed!" message, and send a pull
request to the tip folks.

Meanwhile, I've upgraded one of my test machines to Fedora 20 with grub2
and can reproduce the issue that you and Linus were hitting before the
GOT patch revert. I'll take a look at figuring out what on earth is
going on there.

-- 
Matt Fleming, Intel Open Source Technology Center
