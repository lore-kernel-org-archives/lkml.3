Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbaJNMoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:44:15 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12847 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaJNMoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:44:14 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-f2-543d1a9b728b
Message-id: <1413290650.13192.3.camel@AMDC1943>
Subject: Re: [RESEND PATCH v2 1/4] dmaengine: pl330: Remove non-NULL check for
 pl330_submit_req parameters
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 14 Oct 2014 14:44:10 +0200
In-reply-to: <20141014115118.GG1638@intel.com>
References: <1411994541-31494-1-git-send-email-k.kozlowski@samsung.com>
 <20141014115118.GG1638@intel.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xK7qzpWxDDCZ1W1lsnLGe1eL1v+ks
	FtOnXmC0WD31L6vF2aY37BZLJs9ntbi8aw6bxdojd9kt3r2MsHjZt5/Fgctj8Z6XTB5L3hxi
	9fj49BaLR9+WVYwenzfJeez9/JslgC2KyyYlNSezLLVI3y6BK+P5irXMBZvZKo5uuMzewDiN
	tYuRk0NCwERi7ae1zBC2mMSFe+vZuhi5OIQEljJK/O9cAuV8ZpRYf2g5UxcjBwevgL7Ey8We
	IA3CAjkSmxf+ZwSx2QSMJTYvB6nn5BARUJXY8rODEaSXWeAbk8S9aa/AEixAiVn9z8AaOAX0
	JH4v/Qk2U0ggW2LW9UiQMLOAusSkeYuYQcISAsoSjf1uIGFeAUGJH5PvsUCUyEtsXvOWeQKj
	wCwkHbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgkfN3BuPSY1SFGAQ5G
	JR7egkibECHWxLLiytxDjBIczEoivAoctiFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGB0kghKW
	5ZzV4Dqw24N5XpKoRfu7BbK778X7Lo81SqjQjUx5wXtAIWHa14X7hNuKWc+Kc3085NJ89oOY
	/5/tHEofvFYJ5Zsr+mczZ95ZVZO/w+gRt/eivoBFucz1T5ssli7IfMLhs3VtxtvKzg+zMy92
	87Upfb8i4l96T1VfaU1f48JZKRVXlViKMxINtZiLihMBOERCD2ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-14 at 17:21 +0530, Vinod Koul wrote:
> On Mon, Sep 29, 2014 at 02:42:18PM +0200, Krzysztof Kozlowski wrote:
> > The pl330_submit_req() checked supplied 'struct pl330_thread thrd' and
> > 'struct dma_pl330_desc desc' parameters for non-NULL. However these
> > checks are useless because supplied arguments won't be NULL.
> even if we have some error or bug?
> 
> I would like this to be checked and complained loudly so we know something
> is going wrong rather than assuming it will be correct always.

Currently the driver would fail before or after, regardless of this
check. However I do not insist on this approach.

The first version of patch was little different:
https://lkml.org/lkml/2014/9/5/390

Do you think that 1st version is worth resending?

Best regards,
Krzysztof

