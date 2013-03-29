Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3C2O1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:27:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:58715 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab3C2O1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:27:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,373,1363158000"; 
   d="scan'208";a="309147512"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: amit.daniel@samsung.com, durgadoss.r@intel.com, andi@lisas.de,
        eduardo.valentin@ti.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V2 0/3] Thermal: build all thermal framework code into thermal_sys module
Date: Fri, 29 Mar 2013 22:26:33 +0800
Message-Id: <1364567196-3560-1-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A regression introduced by thermal governor feature
is reported in http://marc.info/?l=linux-kernel&m=136085598604095&w=2

And the root cause is that all the thermal governors can not be registered
successfully when the thermal framework is built as a module.

Thus I made this patch set to build all the thermal framework component,
including governors and cpu_cooling feature into one module so that all the
thermal features are loaded/unloaded altogether.

any comments?

thanks,
rui
