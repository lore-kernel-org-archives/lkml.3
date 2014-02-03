Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaBCSsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:48:03 -0500
Received: from longford.logfs.org ([213.229.74.203]:42711 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaBCSsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:48:01 -0500
Date: Mon, 3 Feb 2014 13:48:57 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140203184857.GA26740@logfs.org>
References: <20140202203617.GA9499@logfs.org>
 <20140203155042.GD9499@logfs.org>
 <20140203163729.GA13634@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140203163729.GA13634@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 February 2014 11:37:29 -0500, Theodore Ts'o wrote:
> 
> So we could take the struct pt_regs which we get from get_irq_regs(),
> XOR them together and use them to feed into input[2] amd input[3] in
> add_interrupt_randomness().  Or some other way of distributing the
> values of all of the irq registers into the __u32 input[4] array.
> 
> That would probably be a good and useful thing to do.  Was that
> basically what you were suggesting?

Yes.

Jörn

--
When you copy some code, you are supposed to read it.  If nothing else,
there's a chance to spot and fix an obvious bug instead of sharing it...
-- Al Viro
