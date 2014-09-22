Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaIVLa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:30:29 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:50055 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaIVLa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:30:28 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <201409221130.s8MBUQls003040@clem.clem-digital.net>
Subject: Corrupt Network Packets -- 3.17-rc5/rc6
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Mon, 22 Sep 2014 07:30:26 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heads up fyi: system is i386 UP.

Started getting some pop3 reception errors from the above system.
Investigating the problem discovered scp of the mailbox failed
with "Corrupted MAC on input"

Problem started with rc5, still in rc6. Running rc4 with no 
problem.

Sorry for lack of better definition.
-- 
Pete Clements 
