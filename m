Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbaIWQLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:11:23 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56103 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaIWQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:11:20 -0400
Date: Tue, 23 Sep 2014 17:11:17 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20140923161117.GJ18635@console-pimps.org>
References: <20140919104021.GA11552@gmail.com>
 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
 <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
 <20140923055802.GA29052@gmail.com>
 <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
 <20140923131805.GH18635@console-pimps.org>
 <CA+55aFyLrvrc2mv0oVPggQjXDVqA2ejZEufEPdMfbW=f_dOqmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyLrvrc2mv0oVPggQjXDVqA2ejZEufEPdMfbW=f_dOqmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep, at 09:05:41AM, Linus Torvalds wrote:
> 
> Well, it boots on my Vaio, fwiw. I'm assume that isn't all that
> interesting, since presumably it's the macbooks that you expected to
> still have problems.

Yeah, though I'm still interested in hearing success stories since it
indicates I didn't screw anything else up while doing the revert.

So, thanks for testing - I feel a bit better about the patch now.

-- 
Matt Fleming, Intel Open Source Technology Center
