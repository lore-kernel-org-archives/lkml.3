Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965891AbaLMIDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 03:03:10 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:46784 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655AbaLMIDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 03:03:08 -0500
MIME-Version: 1.0
Date: Sat, 13 Dec 2014 13:33:07 +0530
Message-ID: <CAJ-jhEfRdFjTKBtLKYjVKwxD5bR4qLftXnKiySShrj4CmcfAqw@mail.gmail.com>
Subject: need help to clear kernel (2.6.16.17) cached memory
From: Manish Yadav <kmanish.ixp@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on my system (based on 2.6.16.17), i am trying to clear the cached
memory but it is not being cleared.

mars# free -m
             total       used       free     shared    buffers     cached
Mem:           925        459        465          0          0        231
-/+ buffers/cache:        228        697
Swap:            0          0          0
mars# sync && echo 3 > /proc/sys/vm/drop_caches
M1450-mrakesh# free -m
             total       used       free     shared    buffers     cached
Mem:           925        459        466          0          0        231
-/+ buffers/cache:        227        697
Swap:            0          0          0
mars#

could you please let me know what i am missing here? as per my
investigation writing 3 to drop_caches should clear the cached memory.

thanks,
manish
