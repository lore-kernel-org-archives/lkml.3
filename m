Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3CQV6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:58:15 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:44534 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3CQV6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:58:14 -0400
Date: Sun, 17 Mar 2013 22:58:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Christopher Li <sparse@chrisli.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] kbuild: avoid some unnecessary rebuild
Message-ID: <20130317215812.GA23103@merkur.ravnborg.org>
References: <CANeU7QkMd_evQrJL1Otp3j3CR9FAXSXO9VOKSFmESkWPZNMkEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANeU7QkMd_evQrJL1Otp3j3CR9FAXSXO9VOKSFmESkWPZNMkEA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 02:50:44PM -0700, Christopher Li wrote:
> In the current tip of git tree. If I do a allmodconfig full build, then follow
> by a "make" again without changing any code in the tree.
> There are some object will always get rebuild. e.g. eboot.o.
> I use "make V=2", it shows that the rebuild is due to some object file
> not in $(targets). I did not understand the $(targets) very well, the
> Kbuild.include mention that It is likely a bug in the kbuild if that
> happen.
> 
> I add them in the $(targets) and that seems avoid the unnecessary
> rebuild of several objects. The second "make" has fewer output.
> The clean rebuild seems works fine too.

We got no patch - just some git help stuff.
Seems you mistyped somthing..

	Sam
