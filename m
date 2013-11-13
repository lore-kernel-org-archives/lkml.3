Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab3KMLQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:16:29 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34608 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3KMLQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:16:27 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/2] ARM & scripts: fix kallsyms regression
Date: Wed, 13 Nov 2013 19:15:49 +0800
Message-Id: <1384341351-4110-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These two patches fix the regression on !MMU by below commit:

f6537f2f0eba4eba("scripts/kallsyms: filter symbols not
in kernel address space")

Thanks,
--
Ming Lei

