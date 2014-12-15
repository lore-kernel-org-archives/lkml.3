Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaLOBHq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 20:07:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:2384 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaLOBHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 20:07:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="498673512"
Message-ID: <1418605658.5745.144.camel@linux.intel.com>
Subject: Re: [LKP] [x86_64, vsyscall] Kernel panic - not syncing: Attempted
 to kill init! exitcode=0x0000000b
From: Huang Ying <ying.huang@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKP ML <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2014 09:07:38 +0800
In-Reply-To: <CALCETrUYd3obWmBRWooA+J1fpxvsjvLEyReZ=2weMUQHhgykrg@mail.gmail.com>
References: <1418605089.5745.139.camel@linux.intel.com>
	 <CALCETrUYd3obWmBRWooA+J1fpxvsjvLEyReZ=2weMUQHhgykrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-14 at 17:03 -0800, Andy Lutomirski wrote:
> On Sun, Dec 14, 2014 at 4:58 PM, Huang Ying <ying.huang@linux.intel.com> wrote:
> > FYI, we noticed the below changes on
> >
> > commit 1ad83c858c7d4ea210429142c99a1548e6715a35 ("x86_64,vsyscall: Make vsyscall emulation configurable")
> >
> 
> This is expected.  You turned off an expert option, disabling
> emulation of a deprecated feature that your init needs. :)  If you
> enable that option but boot with vsyscall=none, you'll get the same
> OOPS, but you'll get a helpful error message, too.
> 
> Either force CONFIG_X86_VSYSCALL_EMULATION=y or upgrade to a modern
> gilbc and make sure you rebuild all your static binaries.

Thanks a lot for your information!  That is helpful for our testing!

Best Regards,
Huang, Ying


