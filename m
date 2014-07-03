Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaGCCEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:04:37 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:62396 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaGCCEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:04:33 -0400
MIME-Version: 1.0
Date: Wed, 2 Jul 2014 22:04:32 -0400
Message-ID: <CAPDOMVh9ojHcwTkGjLtTVgKPnoYs3j54R_PFQoAF+kHAduTM2w@mail.gmail.com>
Subject: FIXME message in arch/arm/mach-omap2/gpmc-onenand.c
From: Nick Krause <xerofoify@gmail.com>
To: khilman@deeprootsystems.com
Cc: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Kevin,
When using csope I get a FIXME message on lines , 321 -325 in
arch/arm/mach-omap2/gpmc-onenand.c on the latest 3.16 r4 code. I was
wondering
if I can remove the legacy code or is it needed still for certain
mach-omap2 based boards.
Cheers Nick
