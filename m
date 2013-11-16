Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3KPNjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 08:39:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab3KPNj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 08:39:29 -0500
From: Thomas Renninger <trenn@suse.de>
To: rjw@sisk.pl
Cc: trenn@suse.de, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Provide cpupower-idle-set(1) manpage and a minor fix
Date: Sat, 16 Nov 2013 14:39:20 +0100
Message-Id: <1384609162-77010-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael: Could you queue these two again in your tree if they are ok, please.

Sidenote:
If I find the time, I like to adjust the cpuidle ladder governor:
If a lighter sleep state is disabled (and in this governor deeper sleep
states are not entered any more as well), I like to set the disabled
flag for the deeper sleep states as well.
Like that the correct kernel behavior (the disabled and all deeper sleep
states are not used anymore) is shown correctly to userspace and this
is not only documented deep inside the kernel sources.

Thanks,

     Thomas

