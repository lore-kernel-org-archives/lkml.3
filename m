Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaDVXje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:39:34 -0400
Received: from one.firstfloor.org ([193.170.194.197]:56523 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaDVXjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:39:32 -0400
Date: Wed, 23 Apr 2014 01:39:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Brian Gerst <brgerst@gmail.com>, Andrew Lutomirski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
Message-ID: <20140422233930.GN22728@two.firstfloor.org>
References: <CAObL_7HdWs2hoNYd0gKzh6iVJr293Z9p+Dg1C6u+5GYQiDfgnA@mail.gmail.com>
 <CA+55aFzRf2Dhh3Eea1E74cpD9DXijUHpsXa71AURy_n6F_JKbw@mail.gmail.com>
 <CAObL_7EL8P0jgnjxkngqso47eFpYXHStNkvpzxSG_xCYgnaHng@mail.gmail.com>
 <CA+55aFwuKTQGHzi-cFkHrkLgkS-kFptajFt4=ginxOgwDcJLrA@mail.gmail.com>
 <5356A70A.5090907@zytor.com>
 <CAObL_7GJypym8JhUmdszDTKJVuLW9wSjbbZK4AZ3Jk304GK6tQ@mail.gmail.com>
 <CAMzpN2hpX=XHFrTKxV1hsngNX4Pmuh9FxjAqeSeQHhEBKza1DA@mail.gmail.com>
 <5356AF9F.4010301@zytor.com>
 <CAMzpN2gkCPZoAKCgXa8tNZYFCuiPd6GWg9yhTBSSA=F43WLv1A@mail.gmail.c!om>
 <5356BA2F.2030007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356BA2F.2030007@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That simply will not work if you can take a #GP due to the "safe" MSR
> functions from NMI and #MC context, which would be my main concern.

At some point the IST entry functions subtracted 1K while the
handler ran to handle simple nesting cases.

Not sure that code is still there.

-Andi
