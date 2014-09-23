Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaIWQSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:18:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbaIWQSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:18:20 -0400
Date: Tue, 23 Sep 2014 12:17:52 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
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
Message-ID: <20140923161751.GB7858@hansolo.jdub.homelinux.org>
References: <20140919104021.GA11552@gmail.com>
 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
 <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
 <20140923055802.GA29052@gmail.com>
 <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
 <20140923131805.GH18635@console-pimps.org>
 <CA+55aFyLrvrc2mv0oVPggQjXDVqA2ejZEufEPdMfbW=f_dOqmQ@mail.gmail.com>
 <20140923161117.GJ18635@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923161117.GJ18635@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 05:11:17PM +0100, Matt Fleming wrote:
> On Tue, 23 Sep, at 09:05:41AM, Linus Torvalds wrote:
> > 
> > Well, it boots on my Vaio, fwiw. I'm assume that isn't all that
> > interesting, since presumably it's the macbooks that you expected to
> > still have problems.
> 
> Yeah, though I'm still interested in hearing success stories since it
> indicates I didn't screw anything else up while doing the revert.

I have it building right now.  I'll test it on both my SB machine, and
my macbook using shim/grub2.

josh
