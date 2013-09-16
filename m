Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab3IPWmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:42:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:56586 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3IPWmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:42:40 -0400
Message-ID: <1379371339.3721.42.camel@pasglop>
Subject: Re: "memory" binding issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        m.szyprowski@samsung.com, swarren@nvidia.com, rob.herring@calxeda.com,
        Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Sep 2013 08:42:19 +1000
In-Reply-To: <0A20DA07-7B18-4BD5-AF32-172022B92611@codeaurora.org>
References: <1379300274.4098.77.camel@pasglop>
	 <0A20DA07-7B18-4BD5-AF32-172022B92611@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 10:22 -0500, Kumar Gala wrote:
> Where is Jermey's binding documented ?

It looks like I actually came up with this binding :-) Jeremy reminded
me yesterday. It was posted to the DT list a while back, arguably we
should have merged it.

> Is there concern of "breaking" whatever got merged in powerpc?

No. I'm happy to switch over to something else but if anybody uses the
current one we have on powerpc, we can keep the code to support it as
well, it's not a lot of it.

Cheers,
Ben.


