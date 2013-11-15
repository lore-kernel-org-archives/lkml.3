Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3KOTHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:07:50 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53956 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3KOTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:07:11 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/3] Kobjectify device tree structures
Date: Fri, 15 Nov 2013 17:46:41 +0000
Message-Id: <1384537604-5032-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've resurrected this series and am posting it for review. I think I've
got the last problem that I know about solved. That was the problem that
Nathan pointed out that modified properties don't get reflected in the
sysfs representation. As I mentioned the last time I posted this series,
I will probably put a kernel release between patches 1&2 and patch 3 so
that if there is any problems then the old /proc method is still
available.

I'm posting this for review, but I've only compile tested on ARM and
PowerPC, and boot tested on ARM. I'll be going though a full set of
builds when I'm no longer on an airplane.  :-)

The existing device-tree userspace ABI remains the same with this series
applied.

Nathan, I would particularly appreciate if you can test this on PowerPC
machines with OF_DYNAMIC.

g.

