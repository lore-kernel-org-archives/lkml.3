Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaIPJrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:47:10 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54679 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaIPJrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:47:07 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-87-54180718c6d6
Message-id: <1410860822.16106.3.camel@AMDC1943>
Subject: Re: [PATCH v6 0/8] charger/mfd: max14577: Add support for MAX77836
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 16 Sep 2014 11:47:02 +0200
In-reply-to: <20140916093000.GA31655@earth.universe>
References: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
 <20140915225220.GH25162@lee--X1> <20140916093000.GA31655@earth.universe>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t/xq7oS7BIhBhtvcljMWb+GzWLjjPWs
	FlMfPmGzmPTkPbPF/CPnWC0mrpzMbNH/ZiGrxblXKxktzja9Ybe4//Uoo8W3Kx1MFpu/d7BZ
	XN41h83ic+8RRou1R+6yWyy9fpHJYsL0tSwWrXuPsFuc7ma1OL27xEHEY828NYwel/t6mTx2
	zrrL7rFy+Rc2j80rtDw2repk87hzbQ+bx4kZv1k85p0M9OjbsorR4/MmuQDuKC6blNSczLLU
	In27BK6MXZd2sBfsZqs4MX0NawPjL5YuRk4OCQETic9t7UwQtpjEhXvr2UBsIYGljBLnVpt2
	MXIB2Z8ZJf7d3gOW4BXQl+hdPJkZxBYW8JZYM20fWJxNwFhi8/IlYLaIgIfEmz/zGUGamQV2
	sUrM/DgZbAOLgKrE/bObGEFsTqDND58tZ4HYMIlRYsesh2AnMQuoS0yatwhoAwfQScoSjf1u
	EIsFJX5MvgdVIi+xec1b5gmMArOQdMxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGCHR+WUH4+JjVocYBTgYlXh4M/6JhwixJpYVV+YeYpTgYFYS4b34ByjEm5JYWZValB9f
	VJqTWnyIkYmDU6qBcaF/yLOIJxWrp+7mtna7zbvP6PDv+b+/HTLR1kmzdN+6p11u2+bFx9Ws
	k7fl3T5oYWfZXXrTUEnykNH8SpX5Ai9r01QPf2xXv7aIxzOpvLqvrEbmojXPd0bl3E9lx7Od
	T5144e8iljanPU7nfIbH2kNfbXozWTata2Hu1PznfUnHZWfPjMp2JZbijERDLeai4kQA8MVC
	qKwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-09-16 at 11:30 +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Mon, Sep 15, 2014 at 11:52:20PM +0100, Lee Jones wrote:
> > On Fri, 12 Sep 2014, Krzysztof Kozlowski wrote:
> > > This is a sixth version of patches adding support for
> > > MAX77836 device to the max14577 drivers.
> > > 
> > > This patchset has been on the lists for quite long time and was already
> > > reviewed by all necessary maintainers except power supply.
> > > I need acks from power supply subsystem (patches: 3, 5-8).
> > 
> > Give this set a few more days for the Power guys to respond.  If they
> > don't, ping me and I will just apply the set.
> 
> Acked-By: Sebastian Reichel <sre@kernel.org>
> 
> -- Sebastian

Thank you.

Lee,
Could you pick up whole patchset with Sebastian's ack?

Best regards,
Krzysztof

