Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaHQRU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:20:59 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48375 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751392AbaHQRU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:20:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1973AQDAaeGCOT86cPznP9ggXLka1DJIXc=
X-DKIM: OpenDKIM Filter v2.0.1 titan 100275C7D5E
Date: Sun, 17 Aug 2014 13:20:51 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sricharan R <r.sricharan@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] irqchip/irq-crossbar: off by one bugs in init
Message-ID: <20140817172051.GF12769@titan.lakedaemon.net>
References: <20140807152821.GB10299@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807152821.GB10299@mwanda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

On Thu, Aug 07, 2014 at 06:28:21PM +0300, Dan Carpenter wrote:
> My static checker complains that the ">" should be ">=" or else we go
> beyoned the end of the cb->irq_map[] array on the next line.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to irqchip/urgent

thx,

Jason.
