Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab3HOPZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:25:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3HOPZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:25:40 -0400
Message-ID: <520CF2EF.8080000@suse.cz>
Date: Thu, 15 Aug 2013 17:25:35 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle/misc/warn.cocci: use WARN
References: <1376313683-32276-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376313683-32276-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.8.2013 15:21, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use WARN(1,...) rather than printk followed by WARN(1).
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  scripts/coccinelle/misc/warn.cocci |  109 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 109 insertions(+)

Hi Julia,

this has been in mainline since v3.8-rc1 as commit ad99ac2.

Michal
