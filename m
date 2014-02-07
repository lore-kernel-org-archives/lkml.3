Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBGXVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 18:21:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60782 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaBGXVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 18:21:44 -0500
Message-ID: <52F56A40.60707@zytor.com>
Date: Fri, 07 Feb 2014 15:20:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Kees Cook <keescook@chromium.org>,
        Cong Ding <dinggnu@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org> <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com> <52E5EFAF.3060609@linux.intel.com> <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com> <52E601DA.7010605@zytor.com> <20140130220708.GP9951@redhat.com> <CAGXu5jKp0j71ucE7uOWRa+gQM1Wzp=_KdByJK4XnACTwiCW4ow@mail.gmail.com> <20140207144914.GA5949@redhat.com> <52F503FD.8080607@linux.intel.com> <20140207162408.GD6967@redhat.com> <20140207231626.GA3840@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20140207231626.GA3840@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 03:16 PM, Dave Young wrote:
> 
> Hi Vivek,
> 
> Chaowang <chaowang@redhat.com> is looking into passing setup_data SETUP_E820_EXT
> instead of using exactmap. Previously Thomas Renninger tried passing them in e820.
> I did not find the old thread, but I remember it's not enough because of the
> 128 entries limitation. 
> 

THERE IS NO SUCH LIMITATION.

Only 128 slots fit in struct boot_params, but additional entries can be
added to the setup_data linked list.

	-hpa

