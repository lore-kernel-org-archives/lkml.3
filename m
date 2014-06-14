Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaFNG1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 02:27:15 -0400
Received: from imap.thunk.org ([74.207.234.97]:38663 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaFNG1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 02:27:13 -0400
Date: Sat, 14 Jun 2014 02:27:10 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Message-ID: <20140614062710.GD6447@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140614030621.GB6447@thunk.org>
 <20140614052527.14849.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614052527.14849.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 01:25:27AM -0400, George Spelvin wrote:
> > When I did a quick comparison of your 64-bit fast_mix2 variant, it's
> > much slower than either the 32-bit fast_mix2, or the original fast_mix
> > alrogithm.
> 
> That is f***ing *bizarre*.  For me, it's *significantly* faster.
> You *are* compiling -m64, right?  Because I agree with you it'd
> be stupid to try to use it on 32-bit machines.

Sorry for not being clear.  My results are similar to yours with -m64.
It was much slower when compiled with -m32.  (Which may have been
obvious, but one of the things I've learned very early on with
benchmarking is you measure, and don't assume, whenever possible....)

	     	    	     	       	       - Ted
