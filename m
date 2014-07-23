Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbaGWULH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:11:07 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40257 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933315AbaGWULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:11:03 -0400
X-Sasl-enc: ddt+YUtB8YN7+bp9ldfSDqRSLN+wy+1WEyMQ/zImtBeR 1406146263
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 0/8] x86, microcode: cosmetic and minor issue fixes
Date: Wed, 23 Jul 2014 17:10:43 -0300
Message-Id: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes a number of cosmetic issues reported by sparse, as well
as some minor issues in the Intel microcode support.

The issues found in the Intel microcode driver are very unlikely to be
triggered by an untampered microcode update... but that could change.

Henrique de Moraes Holschuh (8):
  x86, microcode, amd: fix missing static declaration
  x86, microcode, intel: fix missing static declarations
  x86, microcode, intel: fix typos
  x86, microcode, intel: fix missing declaration
  x86, microcode, intel: don't use fields from unknown format header
  x86, microcode, intel: total_size is valid only when data_size != 0
  x86, microcode, intel: forbid some incorrect metadata
  x86, microcode, intel: correct extended signature checksum
    verification

 arch/x86/include/asm/microcode_intel.h      |    3 +-
 arch/x86/kernel/cpu/microcode/amd_early.c   |    2 +-
 arch/x86/kernel/cpu/microcode/intel.c       |    9 +++--
 arch/x86/kernel/cpu/microcode/intel_early.c |   13 +++++---
 arch/x86/kernel/cpu/microcode/intel_lib.c   |   48 ++++++++++++++++++++++-----
 5 files changed, 57 insertions(+), 18 deletions(-)

-- 
1.7.10.4

