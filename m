Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3DTNuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 09:50:08 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:50186 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab3DTNuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 09:50:07 -0400
MIME-Version: 1.0
Date: Sat, 20 Apr 2013 21:50:05 +0800
Message-ID: <CACbbJyZ8TbmiJZjbzJEdQ0OaWjpScJL+B8=9tKNYki1AhrRE+g@mail.gmail.com>
Subject: [RFC]CPU in SYSFS: what information should be written to
 /sys/devices/system/cpu/probe to add cpu In X86?
From: Ren Zhen <darwin.xupt@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everybody:
     What information should be written to
/sys/devices/system/cpu/probe to add a cpu In X86?
     And, what information should be written to
/sys/devices/system/cpu/release to remove a  cpu In X86?
      I have read the
/Documentation/ABI/testing/sysfs-devices-system-cpu. It says that
      probe:writes to this file will dynamically add a CPU to the
system. Information written to the file to add CPU's is architeture
specific.
      release: writes to this file will dynamically remove a CPU to
the system. Information written to the file to remove CPU's is
architeture specific.
      I just want to know what information should be written to those file.
      Any help will be appreciated!
--
Sincerely,
Ren Zhen
