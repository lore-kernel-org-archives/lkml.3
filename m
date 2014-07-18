Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbaGRIYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 04:24:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759704AbaGRIYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 04:24:18 -0400
Message-ID: <53C8D9AE.8030902@suse.cz>
Date: Fri, 18 Jul 2014 10:24:14 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org
CC: linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: allow to override Python command name
References: <1405658411-27346-1-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1405658411-27346-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 18.7.2014 06:40, Masahiro Yamada napsal(a):
> The specification of Python 3 is largely different from that of
> Python 2.
> 
> For example, arch/ia64/scripts/unwcheck.py seems to be written
> in Python 2, not compatible with Python 3.
> 
> It is not a good idea to invoke python scripts with the hard-coded
> command name 'python'. The command 'python' could possibly be
> Python 3 on some systems.
> For that case, it is reasonable to allow to override the command name
> by giving 'PYTHON=python2' from the command line.
> 
> The 'python' in arch/ia64/Makefile should be replaced with '$(PYTHON)'.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> Cc: linux-ia64@vger.kernel.org

Thanks, applied to kbuild.git#kbuild.

Michal

