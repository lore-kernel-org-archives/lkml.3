Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbaJ1Hxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:53:32 -0400
Received: from atl4mhob15.myregisteredsite.com ([209.17.115.53]:44425 "EHLO
	atl4mhob15.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760922AbaJ1Hx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:53:28 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, michal.simek@xilinx.com, chris@printf.net,
        ulf.hansson@linaro.org
Subject: Re: [PATCH 2/2] mmc/host/sdhci-of-arasan.c: Skip EPROBE_DEFER error messages
Date: Tue, 28 Oct 2014 08:53:20 +0100
Message-Id: <1414482801-3773-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAPDyKFpuiPqZ+5h-SS2-7XeVVh4J2v3SQr=RtjaTZw=0=bXABw@mail.gmail.com>
References: <CAPDyKFpuiPqZ+5h-SS2-7XeVVh4J2v3SQr=RtjaTZw=0=bXABw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed here, I'll post a new patch which simply removes the error
messages.

