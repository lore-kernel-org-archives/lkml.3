Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbbANIwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:52:00 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:62045 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755381AbbANIv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:51:58 -0500
Message-ID: <1421225516.15397.41.camel@x220>
Subject: clocksource: marco: CONFIG_ARCH_ATLAS7?
From: Paul Bolle <pebolle@tiscali.nl>
To: Barry Song <Baohua.Song@csr.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Wed, 14 Jan 2015 09:51:56 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2015 08:51:56.0540 (UTC) FILETIME=[59D5C3C0:01D02FD7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Barry,

Your commit 81428bbe1d8a ("clocksource: marco: Rename marco to atlas7")
is included in today's linux-next (ie, next-20150114). I noticed because
a script I use to check linux-next spotted a problem.

See, your commit renames one reference to CONFIG_ARCH_MARCO to
CONFIG_ARCH_ATLAS7. But there's no Kconfig symbol ARCH_ATLAS7 in
linux-next yet. I assume that one or more patches to add ARCH_ATLAS7 (or
to rename ARCH_MARCO to ARCH_ATLAS7) are queued somewhere. Is that
correct?


Paul Bolle

