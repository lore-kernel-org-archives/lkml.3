Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab3G3XLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:11:30 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:47402 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab3G3XL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:11:28 -0400
Date: Wed, 31 Jul 2013 02:11:20 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
 mitigations
Message-ID: <20130730231120.GC30725@blackmetal.musicnaut.iki.fi>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com>
 <20130730221435.GA22240@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730221435.GA22240@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 30, 2013 at 06:14:35PM -0400, Dave Jones wrote:
> On Tue, Jul 30, 2013 at 12:05:40PM -0700, Kees Cook wrote:
>  > - fuzzing (is anyone running trinity or similar on the ARM tree?)
>  
> Someone was kind enough to send me an arm chromebook, so I tried this just
> last week (albeit, on the 3.4 kernel it shipped with). The results make
> me think the answer is a resounding 'no'.

Shouldn't you run trinity only under QEMU or similar virtual
environment? Don't know about chromebook, but on some of my ARM boards
a misbehaving kernel could at least in theory brick the board...

A.
