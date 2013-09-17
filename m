Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab3IQPxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:53:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55689 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3IQPxw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:53:52 -0400
Subject: Re: "memory" binding issues
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1379371339.3721.42.camel@pasglop>
Date: Tue, 17 Sep 2013 10:53:49 -0500
Cc: devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        m.szyprowski@samsung.com, swarren@nvidia.com, rob.herring@calxeda.com,
        Grant Likely <grant.likely@secretlab.ca>
Content-Transfer-Encoding: 8BIT
Message-Id: <93B04AC6-6A94-476E-873B-D29208115875@codeaurora.org>
References: <1379300274.4098.77.camel@pasglop> <0A20DA07-7B18-4BD5-AF32-172022B92611@codeaurora.org> <1379371339.3721.42.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 16, 2013, at 5:42 PM, Benjamin Herrenschmidt wrote:

> On Mon, 2013-09-16 at 10:22 -0500, Kumar Gala wrote:
>> Where is Jermey's binding documented ?
> 
> It looks like I actually came up with this binding :-) Jeremy reminded
> me yesterday. It was posted to the DT list a while back, arguably we
> should have merged it.

:), can you either repost the binding for discussion or post a link to the old thread.

>> Is there concern of "breaking" whatever got merged in powerpc?
> 
> No. I'm happy to switch over to something else but if anybody uses the
> current one we have on powerpc, we can keep the code to support it as
> well, it's not a lot of it.

cool

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

