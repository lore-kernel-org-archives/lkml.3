Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaJXL5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:57:06 -0400
Received: from atl4mhob19.myregisteredsite.com ([209.17.115.112]:42387 "EHLO
	atl4mhob19.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932382AbaJXL5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:57:02 -0400
X-TCPREMOTEIP: 88.159.208.100
X-Authenticated-UID: mike@milosoftware.com
From: Mike Looijmans <mike.looijmans@topic.nl>
To: mturquette@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: Add TI CDCE925 I2C controlled clock synthesizer driver
Date: Fri, 24 Oct 2014 13:56:54 +0200
Message-Id: <1414151815-21736-1-git-send-email-mike.looijmans@topic.nl>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch contains a driver for an I2C controlled clock synthesizer.
We've been using this driver for a while for creating clock signals 
for HDMI and audio.   
The only thing missing in this patch is the devicetree binding       
information, I intend to add that in a later patch.

Please provide your feedback, any comments facilitating mainline inclusion are welcome.
