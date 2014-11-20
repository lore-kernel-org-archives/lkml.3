Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaKTQyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:54:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbaKTQyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:54:12 -0500
Date: Thu, 20 Nov 2014 11:54:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        WANG Chao <chaowang@redhat.com>, Baoquan He <bhe@redhat.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120165404.GA30170@redhat.com>
References: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141118220254.GA2571@redhat.com>
 <20141119144105.GB108701@redhat.com>
 <20141119150333.GB2953@redhat.com>
 <20141119153852.GA16146@redhat.com>
 <20141119162806.GD2953@redhat.com>
 <20141120161055.GA8309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120161055.GA8309@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 11:10:55AM -0500, Dave Jones wrote:
> On Wed, Nov 19, 2014 at 11:28:06AM -0500, Vivek Goyal wrote:
>  
>  > I am wondering may be in some cases we panic in second kernel and sit
>  > there. Probably we should append a kernel command line automatically
>  > say "panic=1" so that it reboots itself if second kernel panics.
>  > 
>  > By any chance, have you enabled "CONFIG_RANDOMIZE_BASE"? If yes, please
>  > disable that as currently kexec/kdump stuff does not work with it. And
>  > it hangs very early in the boot process and I had to hook serial console
>  > to get following message on console.
> 
> I did have that enabled. (Perhaps the kconfig should conflict?)

Hi Dave,

Can you please also send me your kernel config file. I will try that on
my machine and see if I can reproduce the problem on my machine.

Thanks
Vivek
