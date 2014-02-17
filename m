Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaBQTHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:07:12 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38301 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181AbaBQTHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:07:08 -0500
X-Sasl-enc: OFPAB6zyfVU02sU1e4O1pbDTnqJfnH20Rq3SX/o85ans 1392664026
Date: Mon, 17 Feb 2014 16:07:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Jan Beulich <JBeulich@suse.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Issue a warning if number of present CPUs > maxcpus
 and CONFIG_HOTPLUG=n
Message-ID: <20140217190704.GA24390@khazad-dum.debian.net>
References: <20140215150223.63bb52fb@hananiah.suse.cz>
 <5301D7AA020000780011CBE9@nat28.tlf.novell.com>
 <20140217110402.7e4fc211@hananiah.suse.cz>
 <20140217134006.GA14786@khazad-dum.debian.net>
 <20140217151626.5ff99027@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217151626.5ff99027@hananiah.suse.cz>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Petr Tesarik wrote:
> This results in:
> 
>   total_cpus = 1008   /* this is purely informative, it is *NOT* used
>                          to size anything */
>   possible = 48       /* clamped to nr_cpu_ids */
> 
> A warning message (with or without my patch):
>   1024 Processors exceeds NR_CPUS limit of 48
> 
> Informative message:
>   Allowing 16 CPUs, 32 hotplug CPUs
> 
> No other warning (with or without my patch).

I'd rather no warnings were printed at all (user asked for that nr_cpus,
there is no reason to warn him about it), but your patch didn't cause any
_new_ warnings to be printed anyway.

So, please ignore my comment.  There's no need to change anything in your
patch on my account.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
