Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaCYUaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:30:39 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40965 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaCYUag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:30:36 -0400
From: silvio@port1024.net
To: linux-kernel@vger.kernel.org
Cc: silvio@port1024.net, Silvio F <silvio.fricke@gmail.com>,
        devel@driverdev.osuosl.org
Subject: [WIP] [PATCH 0/3] remove wrong cast of gfp_t flags
Date: Tue, 25 Mar 2014 21:30:17 +0100
Message-Id: <cover.1395778852.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1395362529-17182-1-git-send-email-cse.cem@gmail.com>
References: <1395362529-17182-1-git-send-email-cse.cem@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silvio F <silvio.fricke@gmail.com>

Hi,

I have seen this patch, but in this and two other files we have the same wrong
casting.

This three little patches remove wrong cast for gfp_t-flags in kamlloc,
kzalloc, ...

Please review this patch.

These patches are WIP because I have no hardware and can only do a compile
test.

Cheers,
	Silvio

Silvio F (3):
  staging: vt6655: removed incorrect casting in wpactl.c
  staging: vt6655: removed incorrect casting in ioctl.c
  staging: vt6655: removed incorrect casting in iwctl.c

 drivers/staging/vt6655/ioctl.c  | 6 ++++--
 drivers/staging/vt6655/iwctl.c  | 2 +-
 drivers/staging/vt6655/wpactl.c | 6 +++---
 3 files changed, 8 insertions(+), 6 deletions(-)

-- 
1.9.0

