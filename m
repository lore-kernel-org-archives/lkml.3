Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaH3QDa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 12:03:30 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50102 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbaH3QD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 12:03:29 -0400
Message-ID: <1409414606.21896.105.camel@x220>
Subject: clk: shmobile: CONFIG_ARCH_R8A7794?
From: Paul Bolle <pebolle@tiscali.nl>
To: Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-kernel@vger.kernel.org
Date: Sat, 30 Aug 2014 18:03:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2014 16:03:27.0004 (UTC) FILETIME=[EF294DC0:01CFC46B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hisashi,

Your commit 8de078f189da ("clk: shmobile: Add r8a7794 support") landed
in next-20140828. It adds a single line to a Makefile. That new line
contains a check for CONFIG_ARCH_R8A7794.

There's no Kconfig symbol ARCH_R8A7794 so this line is basically a NOP
currently. I assume that code to add the Kconfig symbol ARCH_R8A7794 is
queued somewhere. Is that correct?


Paul Bolle

