Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3IYDjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 23:39:21 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:36253 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754194Ab3IYDjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 23:39:20 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2013 23:39:20 EDT
MIME-Version: 1.0
Date: Tue, 24 Sep 2013 20:33:04 -0700
Message-ID: <CAL85gmAi9qZWdeHt5JWeEW-OuNKdxqt-0fPDeCugnpun_6BDKA@mail.gmail.com>
Subject: General placement of platform drivers and header files
From: Feng Kan <fkan@apm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

I have some drivers like Queue Manager and co-processor driver that
are used by other
drivers like Ethernet. Would it be appropriate to locate these drivers
under one folder under
drivers/misc/arch_name/xxx.

My other question is on common header files (belonging to Queue
Manager) but is sourced
by Ethernet, where should those reside. Should they go under
linux/include/misc/arch_name
or directly sourced using the ../../../misc/arch_name/headerfile method.

-- 
Feng Kan | Engineer
Ph: 408.543.8382
Em: fkan@apm.com
