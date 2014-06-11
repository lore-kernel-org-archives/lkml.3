Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbaFKQgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:36:35 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:38792 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbaFKQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:36:34 -0400
Date: Wed, 11 Jun 2014 18:36:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Josh Boyer <jwboyer@fedoraproject.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] x86,vdso,kbuild: Fix vdso_install
Message-ID: <20140611163628.GA12685@ravnborg.org>
References: <5398749B.4090209@zytor.com>
 <cover.1402503408.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1402503408.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 09:20:05AM -0700, Andy Lutomirski wrote:
> This changes kbuild slightly because I didn't want to fight with using
> static pattern rules and extra obfuscated fake targets just to write a
> loop.

What are you trying to fix with this?

On my box (32 bit Intel) "make MODLIB=~/mod vdso_install"
works as expected.
Two *.so files are installed as a copy of the so.dbg files.

	Sam
