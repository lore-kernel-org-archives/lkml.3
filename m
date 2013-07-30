Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab3G3XQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:16:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178Ab3G3XQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:16:20 -0400
Date: Tue, 30 Jul 2013 19:15:33 -0400
From: Dave Jones <davej@redhat.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
 mitigations
Message-ID: <20130730231533.GA26824@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Kees Cook <keescook@chromium.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	ksummit-2013-discuss@lists.linuxfoundation.org,
	LKML <linux-kernel@vger.kernel.org>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
 <20130730221435.GA22240@redhat.com>
 <20130730231120.GC30725@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730231120.GC30725@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 02:11:20AM +0300, Aaro Koskinen wrote:
 > Hi,
 > 
 > On Tue, Jul 30, 2013 at 06:14:35PM -0400, Dave Jones wrote:
 > > On Tue, Jul 30, 2013 at 12:05:40PM -0700, Kees Cook wrote:
 > >  > - fuzzing (is anyone running trinity or similar on the ARM tree?)
 > >  
 > > Someone was kind enough to send me an arm chromebook, so I tried this just
 > > last week (albeit, on the 3.4 kernel it shipped with). The results make
 > > me think the answer is a resounding 'no'.
 > 
 > Shouldn't you run trinity only under QEMU or similar virtual
 > environment? Don't know about chromebook, but on some of my ARM boards
 > a misbehaving kernel could at least in theory brick the board...
 
I like to live dangerously.  Don't imitate everything you see on TV,
or read about on lkml.

More seriously, that's true if you're running trinity as root, which
yes, I usually advise people only do in qemu etc.

If you're running it as a regular user and you can brick the board,
you might have bigger problems.

	Dave

