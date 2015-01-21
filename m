Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbbAUOYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:24:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbbAUOYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:24:38 -0500
Date: Wed, 21 Jan 2015 09:24:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: poma <pomidorabelisima@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Jeremy Newton <alexjnewt@hotmail.com>, Thomas Koch <linrunner@gmx.net>,
        =?iso-8859-1?Q?Andr=E9?= Erdmann <dywi@mailerd.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: Uhhuh - Dazed and confused, but trying to continue  :)
Message-ID: <20150121142423.GC116159@redhat.com>
References: <54BB8FFE.5010308@gmail.com>
 <20150119134942.GH116159@redhat.com>
 <54BF6AEC.5090706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BF6AEC.5090706@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:01:32AM +0100, poma wrote:
> On 19.01.2015 14:49, Don Zickus wrote:
> 
> Thank you, in the meantime, I've found what causes non-maskable interrupt, [23]d on CPU 0, on resuming S4,
> on AMD Phenom(tm) II X4 955 Processor.
> 
> /etc/default/tlp
> ...
> # Kernel NMI Watchdog
> # 0=disable (default, saves power) / 1=enable (for kernel debugging only)
> NMI_WATCHDOG=0
> 
> Toggling to 1, messages no longer appear,
> NMI_WATCHDOG=1
> 
> $ cat /proc/sys/kernel/nmi_watchdog
> 1
> $ sysctl kernel.watchdog
> kernel.watchdog = 1
> 
> Isn't it brilliant.


Hehe.  Ok.  All that does is swallow your unknown NMI.  But if that makes
you happy, I am fine with that. :-)

Cheers,
Don
