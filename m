Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab3CINPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 08:15:42 -0500
Received: from lnx500.hrz.tu-darmstadt.de ([130.83.156.225]:50036 "EHLO
	lnx500.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932433Ab3CINPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 08:15:41 -0500
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20795.13818.354694.375448@elektron.ikp.physik.tu-darmstadt.de>
Date: Sat, 9 Mar 2013 14:15:38 +0100
To: linux-kernel@vger.kernel.org
Subject: OOPS with switcheroo and nouveau
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2013.3.9.125416
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

looking for a possible reason for the higher power drain of recent kernels,
as reported in a recent post, I did on my Thinkpad T520 with Opensuse 12.2
and kernel-of-the-day 3.8.2-2-vanilla with
01:00.0 VGA compatible controller: NVIDIA Corporation GF119 [Quadro NVS4200M] (rev a1)

> echo OFF > /sys/kernel/debug/vgaswitcheroo/switch
> rmmod nouveau

This resulted in the rmmod command hanging.

Doing in another console

> echo ON > /sys/kernel/debug/vgaswitcheroo/switch

resulted in a OOPS. I captured the backtrace by photo and can type in
errorprone and send the backtrace on request.

Bye
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
