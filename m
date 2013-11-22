Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab3KVCdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 21:33:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab3KVCdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 21:33:00 -0500
Date: Thu, 21 Nov 2013 21:32:48 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: jerry.hoemann@hp.com, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo.kernel.org@gmail.com>
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Message-ID: <20131122023248.GF31921@redhat.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <528E94D1.2050809@zytor.com>
 <20131121233705.GA32121@srcf.ucam.org>
 <528EAF99.1010503@zytor.com>
 <20131122012524.GA5627@anatevka.fc.hp.com>
 <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 05:29:01PM -0800, Yinghai Lu wrote:
> On Thu, Nov 21, 2013 at 5:25 PM,  <jerry.hoemann@hp.com> wrote:
> > On Thu, Nov 21, 2013 at 05:12:57PM -0800, H. Peter Anvin wrote:
> >
> > Large systems w/ lots of IO require large crash kernel allocations for
> > the kernel to boot.  Then you have to worry about the OOM killer.....
> 
> so go with crashkernel=1024M,high.

He trying to solve problem with older distributions on these machines and
there we do not have crashkernel=X,high option nor do we have capability
to load and boot bzImage above 896MB.

Thanks
Vivek
