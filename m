Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3JNVNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:13:46 -0400
Received: from imap.thunk.org ([74.207.234.97]:46040 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab3JNVNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:13:45 -0400
Date: Mon, 14 Oct 2013 17:13:37 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20131014211337.GD14373@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Pavel Machek <pavel@ucw.cz>, Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
References: <10005394.BRCyBMYWy3@tauon>
 <20130910150419.GA29237@thunk.org>
 <2722901.IcH4JOB8ab@tauon>
 <20130910182524.GE29237@thunk.org>
 <20131010065017.GA1535@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010065017.GA1535@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 08:50:17AM +0200, Pavel Machek wrote:
> On the system with good power management and idle cpus (many of them), I'd
> expect most of the IPs to be pretty much equal -- arch specific version of
> "enter low power state" (mwait on recent intel machines, for example).
> 
> Would it make sense to mix the other registers, too?

Hmm....  Is there a useful way that we can do this in an
architecture-independent way?

						- Ted
