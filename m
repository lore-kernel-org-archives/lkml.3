Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbaGNXIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 19:08:52 -0400
Received: from imp01.mtu.ru ([62.5.255.10]:37000 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbaGNXIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 19:08:51 -0400
X-Spam-Flag: NO
Message-ID: <53C4623F.5090901@pavlinux.ru>
Date: Tue, 15 Jul 2014 03:05:35 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH RT 0/4] Linux 3.2.60-rt89-rc1
References: <20140714200634.590977709@goodmis.org>
In-Reply-To: <20140714200634.590977709@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15.07.2014 00:06, Steven Rostedt пишет:
> Dear RT Folks,
>
> This is the RT stable review cycle of patch 3.2.60-rt89-rc1.

Actually 3.2.61

kernel/irq/manage.c
kernel/rtmutex.c

This files FUZZED :(
