Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166Ab3DSEIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 00:08:30 -0400
Received: from mail.afriserver.de ([5.9.107.143]:47053 "EHLO
	mail.afriserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3DSEI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 00:08:29 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Apr 2013 00:08:29 EDT
Message-ID: <5170C1BB.1090707@felixbecker.name>
Date: Fri, 19 Apr 2013 06:02:03 +0200
From: Felix Becker <mail@felixbecker.name>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: L1-icache-loads statistics on i7 2600k?
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i'm trying to trace the caching behaviour of one of my applications
using the "perf" tool. On my i7 Q 820 i can see the l1 instruction
cache loads using "perf stat -e L1-icache-loads" On my i7-2600k i'm
getting "<not supported> L1-icache-loads"

Tracing the following events works fine:

L1-dcache-loads
L1-dcache-load-misses
L1-icache-load-misses

So do you know why it is possible to read dcache loads / misses and
icache misses, but not icache loads? Doesn't the i7 2600k PMU provide
this value or is something wrong with my kernel on this machine?

Regards

Felix
