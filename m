Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaHFOAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:00:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53595 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaHFOAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:00:00 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E234DC.3050409@roeck-us.net>
Date: Wed, 06 Aug 2014 06:59:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: FRV build failure with latest kernel
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building frv:defconfig ... failed
--------------
Error log:
In file included from kernel/locking/mutex.c:28:0:
kernel/locking/mcs_spinlock.h: In function 'mcs_spin_lock':
kernel/locking/mcs_spinlock.h:87:2: error: implicit declaration of function 'cpu_relax_lowlatency' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [kernel/locking/mutex.o] Error 1

Due to commit 3a6bfbc91d (arch, locking: Ciao arch_mutex_cpu_relax()), which missed frv.

Guenter

