Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab3GaJlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:41:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39377 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759166Ab3GaJlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:41:06 -0400
Date: Wed, 31 Jul 2013 10:40:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
	mitigations
Message-ID: <20130731094012.GU24642@n2100.arm.linux.org.uk>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com> <20130730221435.GA22240@redhat.com> <20130730231120.GC30725@blackmetal.musicnaut.iki.fi> <20130730231533.GA26824@redhat.com> <20130730235834.GD30725@blackmetal.musicnaut.iki.fi> <20130731000444.GC1281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731000444.GC1281@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 08:04:44PM -0400, Dave Jones wrote:
> To use ARM as an example, the bugs I've seen have mostly been in arch specific
> code that does things like page-table manipulation.  The chromebook bugs I
> was hitting for eg were various kinds of PTE corruption warnings. 

Hmm, really?  Did you reported these bugs?  I'm not aware of mainline
having any changes related to bug reports on PTEs on ARM.
