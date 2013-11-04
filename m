Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3KDRsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:48:51 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:49032 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3KDRsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:48:50 -0500
Date: Mon, 4 Nov 2013 18:48:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Russ Anderson <rja@sgi.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        prarit@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
Message-ID: <20131104174841.GA19498@gmail.com>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
 <20131103101825.GA6605@gmail.com>
 <20131103102132.GA6807@gmail.com>
 <20131103155729.GB9944@hansolo.jdub.homelinux.org>
 <20131104065343.GC13030@gmail.com>
 <20131104140141.GC9944@hansolo.jdub.homelinux.org>
 <20131104141051.GA19355@gmail.com>
 <20131104141615.GD9944@hansolo.jdub.homelinux.org>
 <20131104155624.GA31656@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104155624.GA31656@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> > Russ, does SGI (or anyone else that you know of) have x86 hardware 
> > with more than 4096 CPUs?
> 
> Yes.  We have a system in the lab with 254 12-core IVB sockets for a 
> total of 3048 cores.  With HT is it 6096 cpus.

It would then be nice to up MAXSMP to 6144 or so.

Thanks,

	Ingo
