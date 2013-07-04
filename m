Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab3GDFlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:41:50 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52903 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3GDFlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:41:47 -0400
Subject: Does commit interval inExt3/Ext4 really influence performance?
From: Gmail School <yohung.school@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
X-Mailer: iPhone Mail (10B146)
Message-Id: <5846A3E1-D6F3-4A5F-B227-448A33DD84B8@gmail.com>
Date: Thu, 4 Jul 2013 13:41:42 +0800
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (1.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As title, when we change the commit interval from default value, i.e., 5sec, to other large value, for example, 100 sec., etc.

Does it really make the performance higher?

Since I change this value to some large value, running some benchmark(postmark, iozone, bonnie++) to observe it, I didn't find any different between various commit interval value...

Can anyone solve this problem for me?

Thank you very much...