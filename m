Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbbA0JoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:44:06 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:52960 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbbA0Jnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:43:55 -0500
Message-ID: <1422351833.14015.20.camel@x220>
Subject: arm64: USB_ARCH_HAS_EHCI
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Walmsley <paul@pwsan.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 27 Jan 2015 10:43:53 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2015 09:43:54.0162 (UTC) FILETIME=[C373E120:01D03A15]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

Your commit d035fdfa27ac ("arm64: Add Tegra132 support") is included in
today's linux-next (ie, next-20150127). I noticed because a script I use
to check linux-next spotted a minor problem with it.

It adds a select for the Kconfig symbol USB_ARCH_HAS_EHCI. That Kconfig
was obsoleted in v3.11 and removed in v3.15. See commit b797b76fb464
("usb: host: remove USB_ARCH_HAS_?HCI"). That select is now a nop.

Should I submit the trivial patch to remove that line or do you prefer
to do that yourself?

Thanks,


Paul Bolle

