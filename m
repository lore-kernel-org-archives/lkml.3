Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3JCPEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:04:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51538 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3JCPEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:04:48 -0400
Subject: Re: "memory" binding issues
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CD611795-B45E-4E37-B387-76B5C855DEEA@codeaurora.org>
Date: Thu, 3 Oct 2013 10:04:47 -0500
Cc: Grant Likely <grant.likely@secretlab.ca>, devicetree@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        m.szyprowski@samsung.com, swarren@nvidia.com, rob.herring@calxeda.com
Content-Transfer-Encoding: 8BIT
Message-Id: <36039DDA-9013-49D3-A6FD-4C38060C2501@codeaurora.org>
References: <1379300274.4098.77.camel@pasglop> <20130918025714.A69D8C42C8F@trevor.secretlab.ca> <1379492496.6148.35.camel@pasglop> <CD611795-B45E-4E37-B387-76B5C855DEEA@codeaurora.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So where have we gotten on this?
> 
> It seems we are in agreement that:
> 1. reserve memory should be probably be described in nodes
> 2. it should be pulled out of the memory node and put at root level
> 3. Use reg to describe the memory regions for a given node
> 
> Now to figure out about how to convey usage information for the region and possibly driver association.  I agree with Ben that there are probably cases that an associated device node may not exist so that shouldn't be a hard requirement.
> 
> - k

So I think we should revert the patches as we don't seem to be getting anywhere both on discussion or code updates and the v3.12-rc's keep moving along.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

