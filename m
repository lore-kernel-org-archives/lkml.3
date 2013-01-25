Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3AYTqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:46:44 -0500
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:46937 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3AYTql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:46:41 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4 v11] cpufreq: add support for Calxeda ECX-1000 (highbank)
Date: Fri, 25 Jan 2013 13:46:41 -0600
Message-Id: <1359143205-20279-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds cpufreq support for the Calxeda
ECX-1000 (highbank) SoCs. The EnergyCore Management Engine (ECME) on
the ECX-1000 manages the voltage for the part and communications with
Linux through a pl320 mailbox. clk notifications are used to control
when to send messages to the ECME.

Previous versions of this patch set include two other patches. One has
been dropped as unworkable and the other turned out to be unnecessary.

--Mark Langsdorf
Calxeda, Inc.

