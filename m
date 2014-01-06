Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbaAFUJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:09:35 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:60050 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756003AbaAFUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:09:33 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Add Legacy PM OPS usage checks to class, bus, and driver register functions 
Date: Mon,  6 Jan 2014 13:03:20 -0700
Message-Id: <cover.1389034060.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Legacy PM OPS usage checks to class, bus, and driver register functions.
If Legacy PM OPS usage is found, print warning message to indicate that the
driver code needs updating to use Dev PM OPS interfaces. This will help serve
as a way to track drivers that still use Legacy PM OPS and fix them.

This patch set adds Legacy PM OPS usage check and warning to bus_register().
__class_register(), and driver_register().

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

