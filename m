Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaBCWo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:44:57 -0500
Received: from imap.thunk.org ([74.207.234.97]:53882 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbaBCWo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:44:56 -0500
Date: Mon, 3 Feb 2014 17:44:38 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        Geert Uytterhoeven <geert@linux-m68k.org>, tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140203224438.GD22856@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
	blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
	Geert Uytterhoeven <geert@linux-m68k.org>, tg@mirbsd.de
References: <20140202203617.GA9499@logfs.org>
 <20140203155042.GD9499@logfs.org>
 <20140203163729.GA13634@thunk.org>
 <alpine.LFD.2.10.1402032149530.3940@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.10.1402032149530.3940@eddie.linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 09:54:22PM +0000, Maciej W. Rozycki wrote:
> 
>  Can we be sure we don't leak information this way?  Just being 
> paranoid...

The register information will be mixed pretty thoroughly by the time
it gets to the entropy pool, and then we don't ever expose the entropy
pool to userspace.  So no, I don't think we need to worry about
leaking information.

					- Ted
