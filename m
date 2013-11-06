Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3KFMoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:44:05 -0500
Received: from imap.thunk.org ([74.207.234.97]:54916 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360Ab3KFMoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:44:02 -0500
Date: Wed, 6 Nov 2013 07:43:54 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131106124354.GJ14235@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>, Pavel Machek <pavel@ucw.cz>,
	sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
References: <2579337.FPgJGgHYdz@tauon>
 <20131103124135.GB32091@thunk.org>
 <1762585.cs6mj77ady@tauon>
 <4306229.ErfOL470s2@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4306229.ErfOL470s2@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 12:49:45PM +0100, Stephan Mueller wrote:
> Here is a quote from his answer to my question whether he was able to 
> identify the root cause:
> 
> "its inherent in the microtiming of Hardware and there is nothing you 
> can do about it if you want the root cause is quantum physics"

That's unfortunate, since it leaves open the question of whether this
jitter is something that could be at least somewhat predictable if you
had a lot more information about the internal works of the CPU or not....

      	       		   	     	      - Ted
