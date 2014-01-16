Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaAPQS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:18:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:43524 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaAPQSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:18:24 -0500
Message-ID: <52D80649.8040004@linutronix.de>
Date: Thu, 16 Jan 2014 17:18:17 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: pavel@pavlinux.ru
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 0/8] Linux 3.2.53-rt76-rc1
References: <20140116015824.201732155@goodmis.org>	<52D7A93C.9090801@pavlinux.ru> <20140116091847.0786c8af@gandalf.local.home> <52D7EE70.8000509@pavlinux.ru>
In-Reply-To: <52D7EE70.8000509@pavlinux.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 03:36 PM, Pavel Vasilyev wrote:
> $ xz -cd /tmp/patch-3.2.53-rt75-rt76-rc1.patch.xz | patch -p1
> --dry-run
> 
…

> checking file include/linux/smp.h Hunk #1 succeeded at 117 with
> fuzz 1 (offset 16 lines). Hunk #2 FAILED at 147. 1 out of 2 hunks
> FAILED

I just fetched the 3.2.53 tar file & Steven's patches and I applied
the incremental patch and the all-in-one patch and I don't see this
fallout.

Sebastian
