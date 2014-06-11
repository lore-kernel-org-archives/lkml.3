Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaFKTo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:44:58 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:41637 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFKTo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:44:56 -0400
Date: Wed, 11 Jun 2014 21:44:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,build: Fix make -jN modules_install install
Message-ID: <20140611194452.GA25049@ravnborg.org>
References: <37910a32e3d223a688a2743376bdde8fbdc8ef5c.1402515662.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37910a32e3d223a688a2743376bdde8fbdc8ef5c.1402515662.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:41:57PM -0700, Andy Lutomirski wrote:
> Every few months, I forget why I type:
> 
> $ sudo make -j12 modules_install && sudo make -j12 install
> 
> instead of just:
> 
> $ sudo make -j12 modules_install install
> 
> I try the latter, it appears to work, and then my machine won't boot
> because dracut got confused.  This fixes it once and for all: if you
> ask make to install modules and a kernel, you almost certainly want
> the modules installed *first* so that your initramfs scripts can
> find the modules.

Is this problem x86 specific?

	Sam
