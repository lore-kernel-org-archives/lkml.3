Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3BVPIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:08:53 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:63710 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771Ab3BVPIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:08:47 -0500
Date: Fri, 22 Feb 2013 12:08:14 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] tools/perf/Makefile: drop _FORTIFY_SOURCE right before
 redefinition
Message-ID: <20130222150814.GD18567@ghostprotocols.net>
References: <1361528274-27126-1-git-send-email-slyich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361528274-27126-1-git-send-email-slyich@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 22, 2013 at 01:17:54PM +0300, Sergei Trofimovich escreveu:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Gentoo's toolchain sets _FORTIFY_SOURCE by default
> which leads to very obscure error:
> 
> perf # make clean && make
> Makefile:455: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
> Makefile:470: *** No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static.  Stop
> 
> Patch explicitely undefines _FORTIFY_SOURCE. Thanks!

There was a fix merged recently related to this define, can you please
check?

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux

branch

perf/core

This patch:

http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=commitdiff;h=1807606ac70da5cda870362c13e71d60e94f9c13

- Arnaldo
