Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaF1Jw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 05:52:27 -0400
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:59263 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaF1Jw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 05:52:26 -0400
Message-ID: <53AE9058.50902@linicks.net>
Date: Sat, 28 Jun 2014 10:52:24 +0100
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.15.2 build error on AMD64
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everybody,

Today I was trying to build 3.15.2 on AMD64 from kernel 3.14.8 and get this:

   CC      fs/mbcache.o
fs/mbcache.c: In function ‘__spin_lock_mb_cache_entry’:
fs/mbcache.c:134: error: SSE register return with SSE disabled
make[1]: *** [fs/mbcache.o] Error 1

google doesn't reveal much except that floating point shouldn't be used 
in the kernel, but I am not experienced enough to see how or what is 
going on here.

Any help appreciated.

Please cc me.

Nick
-- 
"A bug in the code is worth two in the documentation."
FSF Associate Member 5508
http://linicks.net/
http://pi.linicks.net/
