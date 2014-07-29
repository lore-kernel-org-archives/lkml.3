Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaG2JAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:00:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:46345 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaG2I7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:59:51 -0400
Message-ID: <53D7627D.10005@linutronix.de>
Date: Tue, 29 Jul 2014 10:59:41 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Corey Minyard <cminyard@mvista.com>, minyard@acm.org, rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        tglx@linutronix.d, C.Emde@osadl.org, jkacur@redhat.com,
        paul.gortmaker@windriver.com
Subject: Re: [PATCH] tracing: Always run per-cpu ring buffer resize with schedule_work_on()
References: <1405537633-31518-1-git-send-email-cminyard@mvista.com> <53D6C601.7090803@mvista.com>
In-Reply-To: <53D6C601.7090803@mvista.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 11:52 PM, Corey Minyard wrote:
> Ping, I haven't heard anything on this.

I looks good from my point of view.

Sebastian
