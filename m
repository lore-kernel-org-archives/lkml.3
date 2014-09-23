Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaIWQFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:05:44 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:41103 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbaIWQFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:05:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140923131805.GH18635@console-pimps.org>
References: <20140919104021.GA11552@gmail.com>
	<CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
	<20140923053510.GB27825@gmail.com>
	<20140923053711.GA28704@gmail.com>
	<20140923055802.GA29052@gmail.com>
	<1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
	<20140923131805.GH18635@console-pimps.org>
Date: Tue, 23 Sep 2014 09:05:41 -0700
X-Google-Sender-Auth: M-9fZ19sgkVYhXBjMpgufdtF0y8
Message-ID: <CA+55aFyLrvrc2mv0oVPggQjXDVqA2ejZEufEPdMfbW=f_dOqmQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 6:18 AM, Matt Fleming <matt@console-pimps.org> wrote:
>
> OK, below is what I've got on top of commit f3670394c29f in Linus' tree.
> Please don't anyone pick this up yet, I'm still testing it on my
> machines and it desperately needs some Tested-by tags.

Well, it boots on my Vaio, fwiw. I'm assume that isn't all that
interesting, since presumably it's the macbooks that you expected to
still have problems.

               Linus
