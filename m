Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3APSNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:13:32 -0500
Received: from mail-ye0-f177.google.com ([209.85.213.177]:49572 "EHLO
	mail-ye0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab3APSNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:13:30 -0500
Date: Wed, 16 Jan 2013 15:13:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Re: [perf PATCH] Use pclose() instead of fclose() on pipe stream
Message-ID: <20130116181325.GL5826@ghostprotocols.net>
References: <50D9CDFC.3010101@intra2net.com>
 <20130111041603.GB3054@ghostprotocols.net>
 <1798138.DOH3quA1zP@storm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1798138.DOH3quA1zP@storm>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 16, 2013 at 10:09:48AM +0100, Thomas Jarosch escreveu:
> 
> Alright, looks like I've messed up the "early" error path.
> The "FILE *fp" pointer needs to be initialized to NULL.
> 
> Should I send another patch or do you want to fix it on the fly?

Please send another patch taking this into account.
 
> What about the other patch
> "[perf PATCH] Fix possible (unlikely) buffer overflow"

Its in my perf/core branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux

As soon as Ingo restarts processing pull requests I'll push it.

- Arnaldo
