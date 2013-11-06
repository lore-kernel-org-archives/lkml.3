Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3KFHOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 02:14:15 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:39138 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab3KFHOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 02:14:14 -0500
Message-ID: <5279EC1B.1040709@rosalab.ru>
Date: Wed, 06 Nov 2013 11:13:31 +0400
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Organization: ROSA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Winkler, Tomas" <tomas.winkler@intel.com>
CC: "Usyskin, Alexander" <alexander.usyskin@intel.com>,
        =?UTF-8?B?Tmljb2zDsg==?= =?UTF-8?B?IENvc3Rhbnph?= 
	<abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mei: cancel stall timers in mei_reset
References: <1361817048.3583.1383580128332.JavaMail.root@collab.rosalab.ru> <5278A741.6040206@rosalab.ru> <C980C034A53E0646B96866D6CE3D187A3330D460@HASMSX106.ger.corp.intel.com> <5278DA7C.6010708@rosalab.ru> <5B8DA87D05A7694D9FA63FD143655C1B1AF03AB6@HASMSX106.ger.corp.intel.com>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AF03AB6@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 > Please try to comment out schedule_delayed_work(&dev->timer_work, 
HZ); in pci-me.c

You mean this call in mei_me_pci_resume() rather than in .probe, I 
suppose? There are two such calls in pci-me.c.

Regards,
Eugene

-- 
Eugene Shatokhin, ROSA Laboratory.
www.rosalab.com
