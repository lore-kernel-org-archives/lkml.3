Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3CRIqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:46:43 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:55428 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3CRIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:46:42 -0400
Date: Mon, 18 Mar 2013 09:46:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Borislav Petkov <bp@suse.de>,
        Robert Richter <rric@kernel.org>
Subject: Re: [RFC PATCH 0/3] Perf persistent events
Message-ID: <20130318084638.GC17959@gmail.com>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
 <87d2uxje6u.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2uxje6u.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> So my question is how can an user know which persistent events are 
> available in her system?

I think we need VFS enumeration for that: directories give a high level a 
structure (allowing things like per user contexts) while readdir will give 
list of specific persistent buffer contexts.

Sensible naming convention would be needed to make things easy to discover 
and list - and for active buffers to not be forgotten about.

cgroups or a new 'eventfs' filesystem would be an option.

Thanks,

	Ingo
