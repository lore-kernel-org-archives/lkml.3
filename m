Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaKRJYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:24:07 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:52110 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbaKRJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:24:06 -0500
Message-ID: <1416302641.7024.7.camel@x220>
Subject: ARM: shmobile: ARCH_R8A7793?
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Nov 2014 10:24:01 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2014 09:24:02.0134 (UTC) FILETIME=[64085760:01D00311]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

Your commit 7a2071c58f36 ("ARM: shmobile: Add early debugging support
using SCIF(A)") is included in today's linux-next (ie, next-20141118).
It adds an (optional) dependency on the Kconfig symbol ARCH_R8A7793. But
that symbol isn't part of next-20141118.

Is a patch that adds this symbol queued somewhere?


Paul Bolle 

