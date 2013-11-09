Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3KISUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 13:20:41 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:35814 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3KISUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 13:20:39 -0500
Date: Sat, 9 Nov 2013 21:20:35 +0300 (MSK)
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        Nicol? Costanza <abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <470220772.6267.1384021235775.JavaMail.root@collab.rosalab.ru>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AF07452@HASMSX106.ger.corp.intel.com>
Subject: RE: mei: cancel stall timers in mei_reset
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 6.0.10_GA_2692 (zclient/6.0.10_GA_2692)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>Looks like there is a hiccup in scheduling during resume and timer work is kicked before its time and starts unnecessary  the reset flow.
>Can you check  that the device is in good state (<debugfs>/mei/devastate , it should be ENABLED).

Yes, /sys/kernel/debug/mei/devstate contains "ENABLED" (checked on kernel 3.10.15 I built with schedule_...() commented out).

>We will work on some solution. 

Thanks!

Regards,
Eugene


