Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaKLBKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:10:20 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51246 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaKLBKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:10:15 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] staging: panel: Module parameters clean-up
Date: Wed, 12 Nov 2014 02:08:05 +0100
Message-Id: <1415754489-9097-1-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small set of patches (although it also could be a single patch...)
rearranges groups of defines, redefines and module parameter declarations,
so that they always appear in the same order defined by Kconfig, which
makes it more pleasant to read and understand. It's a preparation for
a bigger clean-up of current init code.

Mariusz Gorski (4):
  staging: panel: Reorder initial DEFAULT_* defines
  staging: panel: Reorder DEFAULT_* values redefines
  staging: panel: Reorder module parameter declarations
  staging: panel: Use better names for two defined values

 drivers/staging/panel/panel.c | 121 ++++++++++++++++++++++--------------------
 1 file changed, 62 insertions(+), 59 deletions(-)

-- 
2.1.3

