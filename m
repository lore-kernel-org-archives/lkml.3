Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320AbaGAWth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:49:37 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:36466 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbaGAWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:49:36 -0400
MIME-Version: 1.0
Date: Tue, 1 Jul 2014 18:49:35 -0400
Message-ID: <CAPDOMVgP83G4-znp=9kB-pBrfd2MUK+xvw1-_cRMXqi9P8hrww@mail.gmail.com>
Subject: FIX ME in function ocpi_enable in file arch/arm/mach-omap1/opci.c
From: Nick Krause <xerofoify@gmail.com>
To: tony@atomide.com
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tony and Russel ,
There is a FIX ME message in this function of the file stated in my
subject line.
I was wondering what locking is needed  here due to not having experience with
omap subsystem(s).
Cheers Nick
