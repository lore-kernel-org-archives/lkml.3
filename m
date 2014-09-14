Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaINFlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 01:41:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:58771 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752339AbaINFlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 01:41:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ITAvvY9luPnZ3u9ta0ZUBrIwPsiNfj1c=
X-DKIM: OpenDKIM Filter v2.0.1 titan 3434B5E12B7
Date: Sun, 14 Sep 2014 01:40:55 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Christoph Lameter <cl@linux.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mark Brown <broonie@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: Tree for Sep 1
Message-ID: <20140914054055.GI21986@titan.lakedaemon.net>
References: <20140901230728.GM29327@sirena.org.uk>
 <1627064.QhxvejlWdk@amdc1032>
 <alpine.DEB.2.11.1409020857110.9201@gentwo.org>
 <alpine.DEB.2.11.1409020958530.9608@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409020958530.9608@gentwo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Tue, Sep 02, 2014 at 10:00:07AM -0500, Christoph Lameter wrote:
> On Tue, 2 Sep 2014, Christoph Lameter wrote:
> 
> > Oww.. This is double indirection deal there. A percpu offset pointing to
> > a pointer?
> >
> > Generally the following is true (definition from
> > include/asm-generic/percpu.h that is used for ARM for raw_cpu_read):
> >
> > #define raw_cpu_read_4(pcp)             (*raw_cpu_ptr(&(pcp)))
> 
> I think what the issue is that we dropped the fetch of the percpu offset
> in the patch. Instead we are using the address of the variable that
> contains the offset. Does this patch fix it?
> 
> 
> Subject: irqchip: Properly fetch the per cpu offset
> 
> The raw_cpu_read() conversion dropped the fetch of the offset
> from base->percpu_base in gic_get_percpu_base.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
