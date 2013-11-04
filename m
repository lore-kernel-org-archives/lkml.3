Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab3KDULQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:11:16 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48682 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3KDULP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:11:15 -0500
Date: Mon, 4 Nov 2013 21:11:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>, Josh Boyer <jwboyer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        prarit@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
Message-ID: <20131104201111.GA19789@gmail.com>
References: <20131103101825.GA6605@gmail.com>
 <20131103102132.GA6807@gmail.com>
 <20131103155729.GB9944@hansolo.jdub.homelinux.org>
 <20131104065343.GC13030@gmail.com>
 <20131104140141.GC9944@hansolo.jdub.homelinux.org>
 <20131104141051.GA19355@gmail.com>
 <20131104141615.GD9944@hansolo.jdub.homelinux.org>
 <20131104155624.GA31656@sgi.com>
 <20131104174841.GA19498@gmail.com>
 <ec38985e-ab71-464a-9565-e56b99d34a05@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec38985e-ab71-464a-9565-e56b99d34a05@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> 8192 maybe?

Yeah, that makes more sense I guess.

Thanks,

	Ingo
