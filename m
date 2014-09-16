Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaIPQ2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:28:36 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33840 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaIPQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:28:34 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-74-5418652e7e4c
Message-id: <1410884908.18259.4.camel@AMDC1943>
Subject: Re: [PATCH v5 0/4] amba/dma: pl330: add Power Management support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 16 Sep 2014 18:28:28 +0200
In-reply-to: <20140916161820.GM12361@n2100.arm.linux.org.uk>
References: <1410872360-27029-1-git-send-email-k.kozlowski@samsung.com>
 <20140916161820.GM12361@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xK7p6qRIhBg0HrCw2zljPajF96gVG
	i9VT/7JaHPizg9HibNMbdoslk+ezWsyaspfJYmHbEhaLy7vmsFl87j3CaHH7Mq/F2iN32S3e
	vYywuHvqKJvF2zvTWSzOnL7EajHh9wU2i+Nrwy1e9u1ncRD2aGnuYfPYvELLY/Gel0wed67t
	YfNY8uYQq8eWq+0sHrPv/mD06NuyitFjxerv7B6fN8l57P38myWAO4rLJiU1J7MstUjfLoEr
	Y8raJvaCrywVKx79YWlg/MDcxcjBISFgItHyLbeLkRPIFJO4cG89WxcjF4eQwFJGic5/qxgh
	nM+MEgvmT2UEaeAV0JeYsMEKpEFYwFPiZOM3FhCbTcBYYvPyJWwgtoiAqcS1R8+YQXqZBday
	StxYe4URJMEioCrx59pLsAZOARuJb9N2MIHYQgKVEu8vfQWzmQXUJSbNWwR1nLJEY78bSJhX
	QFDix+R7LBAl8hKb17xlnsAoMAtJxywkZbOQlC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpec
	n7uJERKPX3cwLj1mdYhRgINRiYc34594iBBrYllxZe4hRgkOZiUR3h++EiFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGA1TjRre6OyYMSl3xe9PFXe5z6032rbrTnXa5fW6hd3PXGZ0Kv78bKjE
	+u/mTXFHTbGXIj/uHZZWtnxv3MpRmnTh0HPrymtJDbG26h4PjK1ad4Qo+z8O7r1+jm3JxGI1
	z83xf+M/yW3WYK1mlI/83ZZu7lTTUdLNVcq1blKFfMGD9z1/zC05lFiKMxINtZiLihMBydb4
	kaUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-09-16 at 17:18 +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 16, 2014 at 02:59:16PM +0200, Krzysztof Kozlowski wrote:
> > Any comments are welcome.
> 
> Thanks, I'm happy with patches 2 and 3.  What's the merge plan for them?

I think everything could be picked by dmaengine maintainers because the
pl330 is the cause of all these patches. On the other hand I could
submit the patches to your patch tracking system.

However I still don't have necessary reviews/acks from PM (patch 1/4)
and dmaengine (patch 4/4). Anyway can I assume that you acked patch 2
and 3?

Best regards,
Krzysztof


