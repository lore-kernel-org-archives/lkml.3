Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaKDItn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:49:43 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:52538 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaKDIth convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 4 Nov 2014 03:49:37 -0500
Message-Id: <5458A12C0200007800044A97@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 04 Nov 2014 08:49:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] x86-64: allow using RIP-relative addressing for
 per-CPU data
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Observing that per-CPU data (in the SMP case) is reachable by
exploiting 64-bit address wraparound, these two patches
arrange for using the one byte shorter RIP-relative addressing
forms for the majority of per-CPU accesses.

1: handle PC-relative relocations on per-CPU data
2: use RIP-relative addressing for most per-CPU accesses

Signed-off-by: Jan Beulich <jbeulich@suse.com>

