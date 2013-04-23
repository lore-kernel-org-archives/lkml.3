Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3DWNHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:07:46 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:64026 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3DWNHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:07:45 -0400
MIME-Version: 1.0
Date: Tue, 23 Apr 2013 21:07:44 +0800
Message-ID: <CACbbJybOB5x=FKA4GADZSPr3=Jr9KOM1aHg3eBipoXLLnJ6fEw@mail.gmail.com>
Subject: [HELP] Documentation on CPU:/sys/devices/system/cpu/cpuX/cache/indexX/shared_cpu_map
From: Ren Zhen <darwin.xupt@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:
    Can anybody help me to understand the usage of 'shared_cpu_map' in
/sys/devices/system/cpu/cpuX/cache/indexX/.
    when I execute the cmd--'#cat shared_cpu_map', it retures '05'.
     And my computer use Ubuntu12.04,Intel core i3 CPU.
     I have read one email in LKML,it says:

"The patch also adds a bunch of interfaces under
/sys/devices/system/cpu/cpuX/cache, showing various information about the
caches.  Most useful field being shared_cpu_map, which says what caches are
shared among which logical cpus. "

     But I still cannot catch the meaning of  'which says what caches
are shared among which logical cpus'.
     Thanks.
--
Sincerely,
Ren Zhen
