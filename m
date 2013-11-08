Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3KHJMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:12:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab3KHJML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:12:11 -0500
Message-ID: <527CAAE7.40709@suse.cz>
Date: Fri, 08 Nov 2013 10:12:07 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] scripts: kallsyms: Use %zu to print 'size_t'
References: <1383878701-17802-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1383878701-17802-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.11.2013 03:45, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Commit f3462aa95 (Kbuild: Handle longer symbols in kallsyms.c) introduced the
> following warning on ARM:
> 
> scripts/kallsyms.c:121:4: warning: format '%lu' expects argument of type 'long unsigned int', but argument 4 has type 'size_t' [-Wformat]

Actually, every 32bit glibc seems to define size_t as unsigned int.

> 
> Use %zu to print 'size_t'.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Thanks, applied to kbuild.git#kbuild.

Michal

