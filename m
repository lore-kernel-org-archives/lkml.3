Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaIVRZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:25:05 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:36018 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaIVRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:25:04 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <201409221724.s8MHOxe5002845@clem.clem-digital.net>
Subject: Re: Corrupt Network Packets -- 3.17-rc5/rc6
To: xiyou.wangcong@gmail.com (Cong Wang)
Date: Mon, 22 Sep 2014 13:24:59 -0400 (EDT)
Cc: clem@clem.clem-digital.net (Pete Clements),
        linux-kernel@vger.kernel.org (linux-kernel),
        netdev@vger.kernel.org (Linux Kernel Network Developers)
In-Reply-To: <CAM_iQpXQcM2E2oez+nNbbecd25fXqOKNqAfoOgCfQ72-VfBOUA@mail.gmail.com>
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cong Wang
  > <clem@clem.clem-digital.net> wrote:
  > > Heads up fyi: system is i386 UP.
  > >
  > > Started getting some pop3 reception errors from the above system.
  > > Investigating the problem discovered scp of the mailbox failed
  > > with "Corrupted MAC on input"
  > >
  > > Problem started with rc5, still in rc6. Running rc4 with no
  > > problem.
  > >
  > > Sorry for lack of better definition.
  > 
  > 
  > Which driver are you using?
  > 
Here's the output from boot log:

 PCI: setting IRQ 11 as level-triggered
 3c59x 0000:00:0d.0: found PCI INT A -> IRQ 11
 3c59x: Donald Becker and others.
 0000:00:0d.0: 3Com PCI 3c900 Cyclone 10Mbps TPC at d8812000.

-- 
Pete Clements 
