Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3EHLIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:08:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51586 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3EHLIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:08:41 -0400
Date: Wed, 8 May 2013 13:08:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.9.1: x86_64 configuration failing to build
In-Reply-To: <Pine.LNX.4.64.1305081147230.9647@axis700.grange>
Message-ID: <Pine.LNX.4.64.1305081307430.11398@axis700.grange>
References: <Pine.LNX.4.64.1305081147230.9647@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:rPuWMOS8mcPmagKn/KCm6IKLNA7ZTpRH+fQ0DCksSU4
 SSelask+jXMHPyhQ0FZY8u60ANKc+wvDQ0gMqTmfhDA6w92C87
 oQm624Ty99bHmY0Iux1OjFJMwZKx1SOE9xH+F/noN5CPskK9ty
 rrOKXeZBlmG5+IhUNML8R7jD/pBwFRUKGz+ayN+uradM6qZA+T
 2nmhW/HoOjV77trgPh6tvhNcOa+BJSM6j59m7qORfbP6p667j9
 vD0++v4WhzxZ2apwjMn5jTuNHQYEc6z9foxHeiDHHhtizXf2j8
 NjljXJafY16YC1Fyja5tMnqa7NUAMfaIE0Oby5iUePKHQt5lpJ
 8iEzo12Al7uH9jOzgpiJLGxyBvkBNXW7b/fDwfOJHIDH/m/NFm
 0Qvp1UbX3Kuhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013, Guennadi Liakhovetski wrote:

> Hi
> 
> Based on an old (2.6.35) configuration for my PC I updated to 3.9.1 and 
> went through make config, automatically called by make bzImage, the 
> resulted configuration couldn't be built:

A "make distclean" fixed it.

Thanks
Guennadi

> scripts/kconfig/conf --silentoldconfig Kconfig
> include/config/auto.conf:8:warning: symbol value 'm' invalid for INTEL_IDLE
> include/config/auto.conf:420:warning: symbol value 'm' invalid for RTC_CLASS
> include/config/auto.conf:514:warning: symbol value 'm' invalid for RTC_LIB
> include/config/auto.conf:883:warning: symbol value 'm' invalid for ACPI_CONTAINER
> 
> *** Error during update of the configuration.
> 
> Updating the configuration per "make menuconfig" doesn't help either.
