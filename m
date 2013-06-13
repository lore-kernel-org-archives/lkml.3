Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab3FMPQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:16:23 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58162 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3FMPQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:16:20 -0400
MIME-Version: 1.0
Date: Thu, 13 Jun 2013 18:16:19 +0300
Message-ID: <CA+ydwtrVHDE65dVTBijGguZDK0+=+tzi+nn1UywRqfn9Rx4ZuA@mail.gmail.com>
Subject: =?windows-1252?B?aW5jbHVkZS9uZXQvaXB2Ni5oOjQwODozODogd2FybmluZzogkSooKHZvaWQgKikmYWQ=?=
	=?windows-1252?B?ZHIrOCmSIG1heSBiZSB1c2VkIHVuaW5pdGlhbGl6ZWQgaW4gdGhpcyBmdW5jdGlvbg==?=
From: Tommi Rantala <tt.rantala@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I'm seeing the following compiler warnings. Do these make any
sense? I'm doing a x86-64 build.

/build/linux/net/ipv4/tcp_metrics.c: In function ‘tcp_peer_is_proven’:
/build/linux/include/net/ipv6.h:408:38: warning: ‘*((void *)&addr+8)’
may be used uninitialized in this function [-Wmaybe-uninitialized]
/build/linux/net/ipv4/tcp_metrics.c:211:23: note: ‘*((void *)&addr+8)’
was declared here
In file included from /build/linux/include/net/inetpeer.h:15:0,
                 from /build/linux/net/ipv4/tcp_metrics.c:16:
/build/linux/net/ipv4/tcp_metrics.c: In function ‘tcp_tw_remember_stamp’:
/build/linux/include/net/ipv6.h:408:38: warning: ‘*((void *)&addr+8)’
may be used uninitialized in this function [-Wmaybe-uninitialized]
/build/linux/net/ipv4/tcp_metrics.c:245:23: note: ‘*((void *)&addr+8)’
was declared here

$ gcc --version
gcc (Ubuntu/Linaro 4.7.3-1ubuntu1) 4.7.3
Copyright (C) 2012 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

config:
http://fpaste.org/18443/13711363/

Tommi
