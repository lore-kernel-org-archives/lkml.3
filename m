Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaAMKCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:02:30 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:55882 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaAMKC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:02:27 -0500
Date: Mon, 13 Jan 2014 11:02:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-Xtensa] [PATCH v2] perf: add support for the xtensa
 architecture
Message-ID: <20140113100224.GA7234@gmail.com>
References: <2681fd21a9ee014ffe77c0ec7304157be7209b6f.1388649430.git.baruch@tkos.co.il>
 <20140113075518.GH4944@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113075518.GH4944@tarshish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Baruch Siach <baruch@tkos.co.il> wrote:

> Hi perf maintainers,
> 
> Ping?
> 
> Anyone taking this for v3.14?

Would be nice to have some indication in the commit log about how it 
was tested, how well it works, what the limitations are, etc.

Just a naked 'enable support' commit tells us very little.

Thanks,

	Ingo
