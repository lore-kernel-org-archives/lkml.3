Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab3KHALF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:11:05 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:34058 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754717Ab3KHALB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:11:01 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 19:11:01 EST
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add Legacy PM OPS usage checks to class, bus, and driver register functions
Date: Thu,  7 Nov 2013 17:03:47 -0700
Message-Id: <cover.1383868060.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Legacy PM OPS usage checks to class, bus, and driver register functions.
If Legacy PM OPS usage is found, print warning message to indicate the driver
code needs updating to use Dev PM OPS interfaces. This will help serve as a way
to track drivers that still use Legacy PM OPS and fix them.

This patch set adds Legacy PM OPS usage check and warning to bus_register(),
__class_register(), and driver_register() functions.

Individual patches in this series are not dependent on each other. The only
reason this is a series is for context and facilitating discussion on the
overall change as opposed individual patches.

Shuah Khan (3):
  drivers/bus: Add Legacy PM OPS usage check and warning to
    bus_register()
  drivers/class: Add Legacy PM OPS usage check and warning to
    __class_register()
  driver: Add Legacy PM OPS usage check and warning to driver_register()

 drivers/base/bus.c    | 3 +++
 drivers/base/class.c  | 4 ++++
 drivers/base/driver.c | 4 ++++
 3 files changed, 11 insertions(+)

-- 
1.8.3.2

