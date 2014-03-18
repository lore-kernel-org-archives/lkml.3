Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaCROYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:24:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:52563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbaCROYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:24:42 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: OT: Re: [PATCH 3/3] x86, vdso32: handle 32 bit vDSO larger one page
Date: Tue, 18 Mar 2014 15:22:09 +0100
Message-ID: <27368739.JufufE7F6v@xrated>
User-Agent: KMail/4.11.5 (Linux/3.11.10-7-desktop; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140313210010.GB3793@tassilo.jf.intel.com>
References: <5321F418.1030304@zytor.com> <53220DEB.6030902@zytor.com> <20140313210010.GB3793@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:EHlD0haTx8P3pBdWl9kiDRFNLRr/DgdpBDhQhtrbVtW
 Cn0Zl/4vOtYchFpAg7wSVicL+UfvvvkVx7oPVq1zLxfBhZWPPF
 zTFuUsxgD6fqIRovaLDiANDSE9u6th0e1pICd30nmWptKeENID
 EPRsF1b37j0J+FbvokIUEtTlTzk5+mLK8UGDzMJoZUOtCiCwQb
 zrrV6xGO+WgRA9XnBCwpV2bHTTtTvbACqy+VD8J1l+CxlK+/BM
 6YPj8cnDNKvMx/tuSPPpXlAjhq12clPMmvPyl1lvQIqbYpe8Op
 RyMaFImXvMINq7BQOKUiDPUhi6HIm2w5rYqmnpCa3kJ24Js9Gw
 sYs0+s/jMzTbrECjLXmg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag, 13. März 2014 14:00:10 Andi Kleen wrote:
 
> At some point the majority of my nfsroot test image were OpenSUSE 9.

Hehe, I had a 9.3 system (2.6.11.4) with an uptime of > 1000 days before power 
outage, and one 11.1 (2.6.27.56), that has an uptime of 1029 days now. While 
git brought in many good aspects, the gain in development speed resulted in 
noticeable decrease of long term stability. And the kernel is a pretty well 
managed project still, compared to other related ones..

> It was the last opensuse system that booted fast without udev or initrd :-)

The ramifications of udev and initrd where tiny, given what systemd has caused 
to openSUSE lately, combined with the (nowadays) usual nfs and autofs 
dysfunctions.. It all made 13.1 sucking rocks. 

SCR,
 Pete

