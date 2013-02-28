Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3B1Mjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 07:39:48 -0500
Received: from mail.pr.hu ([87.242.0.5]:36347 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab3B1Mjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 07:39:47 -0500
X-Greylist: delayed 2292 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2013 07:39:46 EST
Message-ID: <512F4716.4050802@pr.hu>
Date: Thu, 28 Feb 2013 13:01:26 +0100
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: loadavg question
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.9 (-)
X-Scan-Signature: 3be2f66aaf20b59cd4b0edf337d6e8f4
X-Spam-Tracer: backend.mail.pr.hu -1.9 20130228115952Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on an embedded PC (500MHz AMD Geode), we recently tried
to upgrade the kernel. The original version was 2.6.27, the new
ones were 3.3.x and 3.7.x. With the same userspace (a GTK based
GUI constantly querying daemons handling different pieces of
hardware over serial ports), we noticed that loadavg is different
while the idle time (95-97%) is the same. On 2.6.27, the load was
around 0.05-0.3 while on 3.3.x and 3.7.x, it quickly crawled up
to around 5. Has the load calculation changed so dramatically
after 2.6.27?

Thanks in advance,
Zoltán Böszörményi

