Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab3CMOn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:43:29 -0400
Received: from mailfw02.zoner.fi ([84.34.147.249]:48408 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3CMOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:43:28 -0400
Date: Wed, 13 Mar 2013 16:43:02 +0200
From: Lasse Collin <lasse.collin@tukaani.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Florian Fainelli <florian@openwrt.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] decompressors: fix typo "POWERPC"
Message-ID: <20130313164302.61c953cd@tukaani.org>
In-Reply-To: <1363176339.1335.1.camel@x61.thuisdomein>
References: <1363044544.3137.120.camel@x61.thuisdomein>
	<20130313133045.51d44a63@tukaani.org>
	<1363176339.1335.1.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.16; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-13 Paul Bolle wrote:
> Naive question: what is a preboot environment?

I'm not sure how official the term is. I have seen it mostly in
decompressors' files. It's the environment after a boot loader has
loaded the kernel but before the kernel has decompressed itself. On x86
the preboot environment has done its job once "Booting the kernel." has
been printed.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
