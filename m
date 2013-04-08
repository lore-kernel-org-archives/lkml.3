Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936180Ab3DHKD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:03:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:33923 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936149Ab3DHKDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:03:25 -0400
Message-ID: <516295E7.70200@linutronix.de>
Date: Mon, 08 Apr 2013 12:03:19 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 2/3] kernel/SRCU: provide a static initializer
References: <1363702606-31586-1-git-send-email-bigeasy@linutronix.de> <1363702606-31586-2-git-send-email-bigeasy@linutronix.de> <515E7B79.2020707@cn.fujitsu.com>
In-Reply-To: <515E7B79.2020707@cn.fujitsu.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 09:21 AM, Lai Jiangshan wrote:
> Hi, Sebastian

Hi Lai,

> I don't want to expose __SRCU_STRUCT_INIT(),
> due to it has strong coupling with the percpu array.
> 
> I hope other structure which uses SRCU should use init_srcu_struct().

I need a static initialization for this kind. Patch #3 shows one
example I have another one pending for crypto.
Do you have any idea how I could get it done without this? Do you want
to move/merge header files?

> 
> Thanks,
> Lai

Sebastian
