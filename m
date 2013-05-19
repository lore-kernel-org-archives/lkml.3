Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3ESKMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 06:12:14 -0400
Received: from mail-la0-f68.google.com ([209.85.215.68]:34624 "EHLO
	mail-la0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3ESKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 06:12:12 -0400
MIME-Version: 1.0
Date: Sun, 19 May 2013 14:42:10 +0430
Message-ID: <CANeS4r2Zu=1496Te41jTrNDAGL1VsOgNmLNVZS6wrBOmn0-eWw@mail.gmail.com>
Subject: Linux doesn't create /proc/vmcore
From: matt stuart <matt.henry.stuart@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why doesn't linux create /proc/vmcore while kernel conf marked as does?

my running kernel configuration:
CONFIG_DEBUG_INFO=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_PROC_VMCORE=y

my error on the kdump:
kdump-config savecore
running makedumpfile -c -d 31 /proc/vmcore
/var/crash/201305180259/dump-incomplete.
open_dump_memory: Can't open the dump memory(/proc/vmcore). No such
file or directory

makedumpfile Failed.
kdump-config: makedumpfile failed, falling back to 'cp' ... failed!
cp: cannot stat `/proc/vmcore': No such file or directory
kdump-config: failed to save vmcore in /var/crash/201305180259 ... failed!
