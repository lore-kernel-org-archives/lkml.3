Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab3KMMxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:53:09 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:49622 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3KMMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:53:07 -0500
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Nov 2013 07:53:07 EST
Message-ID: <5283737F.8040809@rosalab.ru>
Date: Wed, 13 Nov 2013 16:41:35 +0400
From: Andrey Ponomarenko <aponomarenko@rosalab.ru>
Organization: ROSA Lab
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Linux Kernel ABI Tracker
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've created a new tool for Linux developers: Kernel ABI Tracker 
(http://upstream-tracker.org/kernel/).

This tool looks for new releases of the Linux kernel, builds them and 
tracks API/ABI changes using a set of basic tools: ABI Dumper and ABI 
Compliance Checker.

More info: 
http://wiki.rosalab.com/en/index.php/Blog:ROSA_Planet/Linux_Kernel_ABI_Tracker

Hope it would be useful for someone in this mail list.

Thanks.

-- 
Andrey Ponomarenko, ROSA Lab.

