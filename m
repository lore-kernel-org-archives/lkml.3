Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaIWQBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:01:53 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:36769 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbaIWQBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140923143712.GI18635@console-pimps.org>
References: <20140919104021.GA11552@gmail.com>
	<CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
	<20140923053510.GB27825@gmail.com>
	<20140923053711.GA28704@gmail.com>
	<20140923055802.GA29052@gmail.com>
	<1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
	<20140923131805.GH18635@console-pimps.org>
	<542182E0.6090101@canonical.com>
	<20140923143712.GI18635@console-pimps.org>
Date: Tue, 23 Sep 2014 09:01:50 -0700
X-Google-Sender-Auth: RCvR_x2JrWj03qalHZMfrq__Uj4
Message-ID: <CA+55aFx7XBJJaSO3C=+wjxjYxMdz+x93p6fWwr6_zjyLDTeNnw@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 7:37 AM, Matt Fleming <matt@console-pimps.org> wrote:
>
> I know Josh was in favour of getting this message dropped and treating
> this as a regression fix, but I was erring on the side of caution
> because it's not critical.

I'd certainly prefer this too, because UI also see the annoying
"setup_efi_pci() failed!" at bootup. I've ignored it, but I would
certainly not mind having it gone either. It seems to result in no
actual value.

               Linus
