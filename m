Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaGDEfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 00:35:01 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63209 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaGDEe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 00:34:59 -0400
MIME-Version: 1.0
Date: Fri, 4 Jul 2014 00:34:58 -0400
Message-ID: <CAPDOMViqzoX_VAJKFB34LXLBVUBTbs4hWq-K_8+bC-m2NmahCQ@mail.gmail.com>
Subject: mach-shmobile: FIXME message in file pm-sh732.c
From: Nick Krause <xerofoify@gmail.com>
To: horms@verge.net.au
Cc: magnus.damm@gmail.com, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While searching for FIX ME messages when using cscope on the latest kernels I
get a message on 68 of this file and was wondering what I need to define SMFRAM
as in order for it to point to things needed to support this portion
of the  hardware.
Cheers Nick
