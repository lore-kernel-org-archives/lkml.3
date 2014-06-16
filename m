Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaFPQXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:23:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33810 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaFPQXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:23:06 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: andreas.dilger@intel.com, oleg.drokin@intel.com, tao.peng@emc.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, hpdd-discuss@ml01.01.org
Subject: [PATCH v5] staging: lustre: lclient: fixing coding style issues
Date: Tue, 17 Jun 2014 02:22:14 +1000
Message-Id: <1402935742-18788-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reworked on PATCH 8/8 as per comments provided by "oleg.drokin@intel.com". This includes changes variable name to 'size_index' and type to loff_t instead of 'unsigned long'

