Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaKJKWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:22:17 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:60884 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447AbaKJKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:22:16 -0500
Message-ID: <1415614934.4862.22.camel@x220>
Subject: ARM: sti: SOC_STIH407 and STIH407_RESET?
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Nov 2014 11:22:14 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2014 10:22:15.0144 (UTC) FILETIME=[32B95E80:01CFFCD0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your commit c27321141915 ("ARM: sti: Add STiH407 Kconfig entry to select
STIH407_RESET") was included in today's linux-next (ie, next-20141110).
It adds a Kconfig entry for SOC_STIH407. That entry selects
STIH407_RESET.

There's no Kconfig symbol STIH407_RESET. And there's nothing in
next-20141110 that cares about SOC_STIH407. So this entry is currently a
nop.

I assume that there are one or more patches queued that make this entry
do something. Is that correct?


Paul Bolle

