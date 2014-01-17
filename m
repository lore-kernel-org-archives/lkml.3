Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaAQTG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:06:28 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:47530 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaAQTGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:06:25 -0500
Message-ID: <52D97F2D.1020500@gmail.com>
Date: Fri, 17 Jan 2014 20:06:21 +0100
From: Branimir Maksimovic <branimir.maksimovic@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: vm commit in atop utility steadilly grows (latest mainline kernel
 from git)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday, I have noticed that vmcom steadilly grows (it was 7TB before
I noticed). I compile kernel every day or two after git pull.
Rebooted and then watched atop, vmcom constantly grows.
Didn't notice any of running processes to allocate.
Booted in 3.12.8 kernel and everything is back to normal.
Since this is pretty noticable, I guess that this is caused by commit
between rc8 release and now, not sure.
Machine is i5 3570k, motherboard asus maximus gene v.


