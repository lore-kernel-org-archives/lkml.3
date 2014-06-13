Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaFMUEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:04:35 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:51827 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaFMUEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:04:33 -0400
Date: Fri, 13 Jun 2014 22:04:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-arch@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC 00/10] tools: Revamp the unaligned endian access
 functions
Message-ID: <20140613200405.GA12362@ravnborg.org>
References: <1402441994-16780-1-git-send-email-hpa@zytor.com>
 <20140611192111.GB16069@ravnborg.org>
 <5398CFA4.60202@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5398CFA4.60202@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > A much simpler approach without any fallback to arch specific
> > version etc. is everything we need.
> 
> It doesn't matter so much for things that are just done for the kernel
> compile, no, but there are some tools that are built to be used as
> standalone things, and it could matter there.
Which tools require 452 lines of codes for a simple set of
le/be wrappers?
In other words - which tool will benefit from the addition speedup
this amount of code gives?

If I as a naive user look in unaligned.h I do not even see
a prototype of the available methods. I am thrown to a directory
with no less than 12 files.

The le_direct.h´+ be_direct.h files seems unused.

So again - why is it not enaough to provide only le_byteshift.h
+ the be counterpart?

	Sam
