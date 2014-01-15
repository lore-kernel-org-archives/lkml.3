Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaAOEMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:12:53 -0500
Received: from forward1h.mail.yandex.net ([84.201.187.146]:33112 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaAOEMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:12:49 -0500
From: Victor Porton <porton@narod.ru>
Envelope-From: porton@yandex.ru
To: linux-kernel@vger.kernel.org
Subject: Notifying on empty cgroup
MIME-Version: 1.0
Message-Id: <135711389759165@web22h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 15 Jan 2014 06:12:45 +0200
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to write software which needs to receive a signal when the cgroup 
created by it becomes empty. (After this the empty cgroup should be deleted 
just not to clutter the memory.)

If the kernel does not support such notifications, it should be improved. 
This functionality is crucial for some kinds of software.

There is /sys/fs/cgroup/systemd/release_agent but I don't understand how to 
use it. I don't understand why we would need it at all.

Starting a binary on emptying a cgroup with the purpose to notify an other 
binary looks like a big overkill. Also my program should work in userspace 
without the need to use release_agent which can be accessed only by root.

Note that my work is related with sandboxing software (running a program in 
closed environment, so that it would be unable for example to remove user's 
files).

See also
http://portonsoft.wordpress.com/2014/01/11/toward-robust-linux-sandbox/

-- 
Victor Porton - http://portonvictor.org
