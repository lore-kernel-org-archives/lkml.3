Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbaGWMdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:33:02 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64165 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751511AbaGWMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:33:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19InzHWoMKx4PvTYUV0tO+NENE69/v5eRs=
X-DKIM: OpenDKIM Filter v2.0.1 titan CC5E55B3CD5
Date: Wed, 23 Jul 2014 08:32:43 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: weiyj_lk@163.com
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ARM: mvebu: fix return value check in
 armada_xp_pmsu_cpufreq_init()
Message-ID: <20140723123243.GE23220@titan.lakedaemon.net>
References: <1406038688-26417-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406038688-26417-1-git-send-email-weiyj_lk@163.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 10:18:08PM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function clk_get() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value
> check should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  arch/arm/mach-mvebu/pmsu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied to mvebu/soc.

thx,

Jason.
