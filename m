Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654Ab3JQUvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:51:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58465 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762335Ab3JQUve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:51:34 -0400
Date: Thu, 17 Oct 2013 13:51:32 -0700
From: David Brown <davidb@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv6 2/4] ARM: msm: Add support for APQ8074 Dragonboard
Message-ID: <20131017205132.GA3459@codeaurora.org>
References: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 11:25:10AM -0700, Rohit Vaswani wrote:
>This patch adds basic board support for APQ8074 Dragonboard
>which belongs to the Snapdragon 800 family.
>For now, just support a basic machine with device tree.
>
>Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
>---

Do you mind putting some history in the commentary part of your
patches, especially, like this one, when you make it to v6.  Just a
brief description of what you've changed makes it a lot easier for
reviewers to determine if their concern has been addressed, and what
else might have changed.

This missed yesterday's pull request, so I'll probably make another
one to include this.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
