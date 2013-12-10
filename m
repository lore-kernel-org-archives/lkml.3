Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3LJDxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:53:40 -0500
Received: from ttcsn157-7.ttc.cz ([212.158.157.7]:37183 "EHLO ixit.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab3LJDxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:53:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 10 Dec 2013 04:51:41 +0100
From: David Heidelberger <david.heidelberger@ixit.cz>
To: John <da_audiophile@yahoo.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] expand micro-optimizations in kernel to newer model CPUs
In-Reply-To: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com>
References: <1386518000.90452.YahooMailNeo@web140004.mail.bf1.yahoo.com>
Message-ID: <864985fbeb1d8148439e25ec01f47a67@ixit.cz>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patch is used in Gentoo geek-sources and mptcp-sources (and 
probably in lot other kernel sources sets). So, there was lot testing.

It's not _big_ performance difference, but -mtune=native is nice to 
have.
It could be great, if this kernel option could be fully utilized without 
need of additional patching.

Thank for your work guys.

Cheers,
David

Dne 2013-12-08 16:53, John napsal:
> I have been maintaining the attached patch since kernel v3.9.[1]  I
> submit for review the most recent incarnation which works with the
> v3.12 tree.  As you can see by the ANOVA plots referenced in the
> comments, these micro optimizations are value-added statistically
> based on a compilation endpoint and are on-par with the included
> "core2" option in the mainline kernel itself.
> 
> I maintain an unofficial Arch Linux kernel repo and have been
> building/packaging kernels using this patch for many different CPUs
> and Arches.  I feel this code has been tested by the >2,500 users of
> my repo on many different CPUs and under both x86 and x86_64
> systems[2] and feel it is worth for inclusion into the mainline
> kernel.
> 
> Please cc me on replies as I am NOT a regular subscriber to lkml. 
>  Thank you.
> 
> 1. https://github.com/graysky2/kernel_gcc_patch
> 2, http://repo-ck.com/stats.pdf
