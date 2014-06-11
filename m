Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaFKT0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:26:04 -0400
Received: from imap.thunk.org ([74.207.234.97]:34004 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbaFKT0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:26:01 -0400
Date: Wed, 11 Jun 2014 15:25:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, price@mit.edu
Subject: Re: drivers/char/random.c: More futzing about
Message-ID: <20140611192557.GE27151@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org,
	mingo@kernel.org, price@mit.edu
References: <20140609013553.GA1167@thunk.org>
 <20140609131738.13625.qmail@ns.horizon.com>
 <20140611163818.GD27151@thunk.org>
 <5398885F.10206@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5398885F.10206@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 09:48:31AM -0700, H. Peter Anvin wrote:
> While talking about performance, I did a quick prototype of random using
> Skein instead of SHA-1, and it was measurably faster, in part because
> Skein produces more output per hash.

Which Skein parameters did you use, and how much stack space was
required for it?  Skein-512 is described as needing 200 bytes of
state, IIRC (which I assume most of which comes from Threefish key
schedule). 

						- Ted
