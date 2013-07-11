Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3GKJtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:49:23 -0400
Received: from plane.gmane.org ([80.91.229.3]:46489 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab3GKJtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:49:21 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: 3.10.0: Full dynticks = high load
Date: Thu, 11 Jul 2013 06:49:04 -0300
Organization: http://www.youtube.com/DanielFragaBR
Message-ID: <krlv29$jbp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 177.102.3.30
X-Newsreader: Claws Mail 3.9.0cvs128 (GTK+ 2.24.14; x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I upgraded to kernel 3.10.0 and decided to try the new "Full
dynticks system (tickless)" option, but now the system load is always
at 1 or above.

	Using the previous "Idle dynticks system (tickless idle)" solves
the problem, so it seems the new Full dynticks code is causing this.

	Maybe Ingo Molnar can help to debug this (I put this in Power
Management, but if it should be in other area, please change).

My desktop is:
Asus P8Z68-V Pro/Gen3
Core i7 2700k
8GB RAM

	Feel free to suggest how can I debug this to help you. I can try
patches if you want.

	Thank you.

-- 
Linux 3.10.0: Unicycling Gorilla
http://www.youtube.com/DanielFragaBR
http://www.libertarios.org.br


