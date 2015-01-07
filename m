Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbbAGCRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:17:34 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53349 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618AbbAGCRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:17:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18eCEBHHtkJucihMBR0SsfeUMoeu3y4+qU=
X-DKIM: OpenDKIM Filter v2.0.1 titan CFA6D63EEEE
Date: Tue, 6 Jan 2015 21:17:25 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Wang Long <long.wanglong@huawei.com>
Cc: tglx@linutronix.de, haojian.zhuang@linaro.org,
        linux-kernel@vger.kernel.org, peifeiyue@huawei.com,
        huxinwei@huawei.com
Subject: Re: [PATCH] irq: irq-hip04: initialize hip04_cpu_map to 0xffff
Message-ID: <20150107021725.GB24989@titan.lakedaemon.net>
References: <1418295816-179583-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418295816-179583-1-git-send-email-long.wanglong@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 11:03:36AM +0000, Wang Long wrote:
> HiP04 GIC extends to support 16 cores, so we should
> initialize the hip04_cpu_map to 0xffff.
> 
> Signed-off-by: Wang Long <long.wanglong@huawei.com>
> ---
>  drivers/irqchip/irq-hip04.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to irqchip/urgent with Haojian Zhuang's Ack.

thx,

Jason.
