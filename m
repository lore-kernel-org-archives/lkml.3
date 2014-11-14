Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaKNIOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:14:53 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16485 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaKNIOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:14:51 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-29-5465b9f924eb
Message-id: <1415952888.25732.3.camel@AMDC1943>
Subject: Re: [PATCH v11 1/6] PM / Runtime: Add getter for querying the IRQ safe
 option
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Fri, 14 Nov 2014 09:14:48 +0100
In-reply-to: <3087810.nyWZ4cyKAA@vostro.rjw.lan>
References: <1415802748-30530-1-git-send-email-k.kozlowski@samsung.com>
 <1415802748-30530-2-git-send-email-k.kozlowski@samsung.com>
 <3087810.nyWZ4cyKAA@vostro.rjw.lan>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e/4Fd1fO1NDDC4GW2ycsZ7VYvrUC4wW
	q6f+ZbV4uvkxk8XZpjfsFp0Tl7BbzJqyl8ni8q45bBafe48wWty+zGux9shddou7p46yWZw5
	fYnVYsLvC2wWx9eGW7zs28/iIODR0tzD5jG7Yyarx+I9L5k8Nq3qZPO4c20Pm8eWq+0sHrPv
	/mD06NuyitFjxerv7B6fN8kFcEVx2aSk5mSWpRbp2yVwZcz/NJ+lYAlbxb1jzcwNjP9Yuhg5
	OSQETCQe7Z3MBmGLSVy4tx7I5uIQEljKKLHnTAuU85lRYuOaq4wgVbwC+hKHNr5lBrGFBSIk
	bnduBouzCRhLbF6+BGySiIC2xNyeU8wgzcwCZ1kk7s1azwqSYBFQlZi2chFYA6eAgUT7lcnM
	EBtWM0qsXfmEHSTBLKAuMWneIqAEB9BNyhKN/W4QiwUlfky+xwJRIi+xec1b5gmMArOQdMxC
	UjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCHx9nUH49JjVocYBTgYlXh4NTJT
	Q4RYE8uKK3MPMUpwMCuJ8F7bDhTiTUmsrEotyo8vKs1JLT7EyMTBKdXAaHV54cavgR3b9l+a
	9iB65reCE21sXOprQuV1lj5ONSx4dnS59dJinViL5icN51K0+Gdk1oenMKYK6G7bMye901n6
	f5F9xBzJv4oGXe5hahPEBB9vX76VZdrFI1tXpzyo009oOyjDac+V1uytWFfNoijb8Lul8wKX
	3rNCwwpTu96LgTdvfvNWYinOSDTUYi4qTgQA2I7M+ZUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-13 at 02:34 +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 12, 2014 03:32:23 PM Krzysztof Kozlowski wrote:
> > Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> > PM IRQ safe was set or not.
> > 
> > Various bus drivers implementing runtime PM may use choose to suspend
> > differently based on IRQ safeness status of child driver (e.g. do not
> > unprepare the clock if IRQ safe is not set).
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> I'm fine with this one, please feel free to add my ACK if that needs to go
> through a different tree.

Thanks!

With your ack I'll push patchset through Russell's patch system.

Best regards,
Krzysztof



