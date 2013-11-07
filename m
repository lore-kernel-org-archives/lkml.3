Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3KGXWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:22:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52701 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3KGXV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:21:59 -0500
From: Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: common location for devicetree files
Date: Thu, 7 Nov 2013 17:21:58 -0600
Message-Id: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
To: devicetree@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1283)
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we start having more sharing of device trees between architectures (arm & arm64, arm & powerpc, guessing maybe mips & arm) we need dts to live in location that 

I was wondering what people felt about doing:

	arch/dts/<VENDOR>/

as a common location that could be shared.  I'm up for other suggestions.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

