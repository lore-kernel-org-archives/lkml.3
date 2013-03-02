Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3CBCFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 21:05:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49360 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab3CBCFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 21:05:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] PM / QoS: Fix device PM QoS problems
Date: Sat, 02 Mar 2013 03:02:57 +0100
Message-ID: <2252670.qpofTRSm2a@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some issues with the device PM QoS core code have been uncovered recently
and the following two patches are supposed to fix them.

[1/2] Fix concurrency problems and memory leaks in device PM QoS core.
[2/2] Fix removal of device PM QoS attributes during device remove.

On top of the current Linus' tree.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
