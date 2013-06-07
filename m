Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3FGIcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:32:06 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:43424 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3FGIcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:32:03 -0400
Date: Fri, 7 Jun 2013 10:31:55 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: NULL pointer dereference when loading the gre module (3.10.0-rc4)
Message-ID: <20130607083155.GB15083@uio.no>
References: <20130606221656.GA11475@uio.no>
 <20130607030648.GA28618@home.goodmis.org>
 <1370577588.24311.407.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370577588.24311.407.camel@edumazet-glaptop>
X-Operating-System: Linux 3.10.0-rc4 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 08:59:48PM -0700, Eric Dumazet wrote:
> Steinar, please make sure you recompiled your modules, because this
> looks like you loaded old modules.

I compiled the kernel using make-kpkg, so I don't see how that would happen.
Also, the timestamps indicate everything is fine:

-rw-r--r-- 1 root root 2574976 Jun  6 00:39 /boot/vmlinuz-3.10.0-rc4
-rw-r--r-- 1 root root   22856 Jun  6 00:39 /lib/modules/3.10.0-rc4/kernel/net/ipv4/ip_gre.ko

Or from the source tree:

-rw-r--r-- 1 root root 2574976 Jun  6 00:36 arch/x86/boot/bzImage
-rw-r--r-- 1 root root   22800 Jun  6 00:39 ./net/ipv4/ip_gre.ko

/* Steinar */
-- 
Homepage: http://www.sesse.net/
