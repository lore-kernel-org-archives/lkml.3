Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3HAAmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:42:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50743 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3HAAmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:42:19 -0400
Date: Wed, 31 Jul 2013 17:42:17 -0700
From: David Brown <davidb@codeaurora.org>
To: ksummit-2013-discuss@lists.linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [ARM ATTEND] DT binding and support and general SOC
Message-ID: <20130801004217.GA12730@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qualcomm is starting to ramp up actually contributing support for MSM
to the mainline kernel.  There are at least a couple of areas where I
see direct discussion involvement would be useful:

  - DT binding.  The Qualcomm out-of-tree code has roughly 37k lines
    of dts/dtsi files.  There has been a lot of effort here to try an
    manage/organize these bindings, but for the most part, this work
    has happened entirely internally.  As more MSM code is
    contributed, there will be a lot more bindings coming in.  I can
    bring experience with what we've done/learned with our current
    internal bindings, as well as bring feedback to more align our
    work with how the ARM bindings in general are moving.

  - SoC code structure and layout.  As ARM increases in variants (new
    CPU types, lots of SoCs, 64-bit etc), I think we should have some
    discussion of how to best organize the code.

David Brown

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
