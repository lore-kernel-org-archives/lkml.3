Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaBCDew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 22:34:52 -0500
Received: from longford.logfs.org ([213.229.74.203]:42693 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaBCDeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 22:34:50 -0500
Date: Sun, 2 Feb 2014 22:35:48 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Stephan Mueller <smueller@chronox.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140203033548.GC9499@logfs.org>
References: <20140202203617.GA9499@logfs.org>
 <16782692.5vMS7Bhbvf@myon.chronox.de>
 <20140203013922.GB6264@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140203013922.GB6264@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 February 2014 20:39:22 -0500, Theodore Ts'o wrote:
> 
> The real question is how much overhead does it add, and is it worth
> it.  Jörn, I take it that was the reason for creating an even faster,
> but weaker mixing function?  Was the existing "fast mix" causing a
> measurable overhead, or was this your just being really paranoid about
> not adding anything to the various kernel fastpaths?

It was paranoia.  And I am still somewhat paranoid and don't trust my
benchmark results yet.  Maybe on an 1024-CPU Altix with a 100k-thread
workload the overhead is too much.  Just because I couldn't measure a
difference on my wimpy notebook does not mean much.

Jörn

--
One of the painful things about our time is that those who feel certainty
are stupid, and those with any imagination and understanding are filled
with doubt and indecision.
-- Bertrand Russell
