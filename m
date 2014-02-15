Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaBOSWc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:22:32 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44027 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaBOSWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:22:31 -0500
From: Jassi Brar <jassisinghbrar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCHv3] Generic Mailbox API
Date: Sat, 15 Feb 2014 23:52:06 +0530
Message-Id: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

  Here is what the generic mailbox api looks like after modifications
to make it work with 5 different platforms.
 Major feedback from Suman Anna(TI), LeyFoon Tan(Intel),
Craig McGeachie(Broadcom) and Loic Pallardy(ST).

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
