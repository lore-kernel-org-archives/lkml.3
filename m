Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab3LGMyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 07:54:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:34508 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab3LGMyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 07:54:04 -0500
Date: Sat, 7 Dec 2013 13:54:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
In-Reply-To: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1312071351510.30673@ionos.tec.linutronix.de>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

On Sat, 7 Dec 2013, Len Brown wrote:
>
> How shall we proceed?

Can you please gather a function trace so I can see what the system is
doing? Preferrably with 3.13-rc3 so we have Peters fix included.

Please send it offlist or put it somehwere for download.

Thanks,

	tglx
