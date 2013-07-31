Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab3GaAF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979Ab3GaAFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:05:25 -0400
Date: Tue, 30 Jul 2013 20:04:44 -0400
From: Dave Jones <davej@redhat.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
 mitigations
Message-ID: <20130731000444.GC1281@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Kees Cook <keescook@chromium.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	LKML <linux-kernel@vger.kernel.org>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
 <20130730221435.GA22240@redhat.com>
 <20130730231120.GC30725@blackmetal.musicnaut.iki.fi>
 <20130730231533.GA26824@redhat.com>
 <20130730235834.GD30725@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730235834.GD30725@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 02:58:34AM +0300, Aaro Koskinen wrote:

 > Anyway, I think it would be interesting to learn about arch-specific
 > bugs discovered with trinity. Quickly thinking, the results should be
 > mostly same regardless of the architecture since the code being tested
 > is generic especially when running as a regular user. But of course
 > there are 32/64-bit and big-endian/little-endian and such differences,
 > and maybe some permission bugs (likely in vendor kernels).

To use ARM as an example, the bugs I've seen have mostly been in arch specific
code that does things like page-table manipulation.  The chromebook bugs I
was hitting for eg were various kinds of PTE corruption warnings. 

ISTR the ia64 & sparc64 bugs it discovered long ago were also due to
things like missing cache flushes, as well as trivial fence-post errors.

	Dave

