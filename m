Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3BMJX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:23:29 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48828 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3BMJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:23:27 -0500
Date: Wed, 13 Feb 2013 10:23:22 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: kvmtool tree (Was: Re: [patch] config: fix make kvmconfig)
Message-ID: <20130213092322.GE7630@gmail.com>
References: <CA+55aFzXF-4Xwc4HU8vnTin4WqtvYcpXq0TsqTN_vRg=myLH_Q@mail.gmail.com>
 <20130211122654.GA5802@gmail.com>
 <CA+55aFwq+_TvOZNEPO-eFPjYuPuMFL0bgR0x=nLq_tvfATqaTA@mail.gmail.com>
 <20130211172807.GA9716@gmail.com>
 <CA+55aFx-0-qcYMqH2wnJJ7iAPhoEvD_EQ0xqVW3VGS3G9=_1_w@mail.gmail.com>
 <20130211175856.GC9716@gmail.com>
 <CA+55aFxpH2A5pTkeAt-bapN6Erac7SSEUhS9qaZ6jUhm_0EAtA@mail.gmail.com>
 <20130212095249.GC20039@gmail.com>
 <511B4D76.50504@redhat.com>
 <CAOJsxLEn2c2cDTeeF5ONDe1cA22Cwj-EjE8mUtC3KH9-UQgP9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLEn2c2cDTeeF5ONDe1cA22Cwj-EjE8mUtC3KH9-UQgP9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> I think Ingo confused virtio and vhost. IIRC, Asias developed 
> vhost-blk using tools/kvm.

Erm, indeed - sorry.

Thanks,

	Ingo
