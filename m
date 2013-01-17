Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab3AQKwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:52:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab3AQKwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:52:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [RFC PATCH v1 25/31] ARC: [plat-arcfpga] Hooking up platform to ARC UART
Date: Thu, 17 Jan 2013 10:52:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211071416.08012.arnd@arndb.de> <50F7A862.4050006@synopsys.com>
In-Reply-To: <50F7A862.4050006@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301171052.03189.arnd@arndb.de>
X-Provags-ID: V02:K0:8UACJ2CyBTSr+3xEmaZVGnwkcjUq0Vngvo+twA7PIGi
 B//ybRQGZKoUevuL2NMb2rQqGp7yLhHwFcgXLuRfVzQy4UoANZ
 iDsFYpNuLwO9k2gBPgaQ7RqYdCVGZUxknmDE/77SvLmu1o17Cj
 M4BEmuy822oQE92T91xBbLfcLP6vJAoS0aUm0HzuPu0iJcxnR0
 ytqLTqtf9/QOarTSkuqsjPZuYDwslRW9mBKm+CTQIxZoMPNAwk
 1GjuvayCKHxOtqYIC5sDpjzInXmbi2BzRo2q3t7ilX8/FJqUxf
 HA288Prbprl/VqRgVcEjDV1fkl4Ap8ffByXcDNi1FJvjlju6L1
 6s4jJF740VcHXR1t7df4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2013, Vineet Gupta wrote:
> So my strategy for v2 series (based off 3.8-rcx) is to introduce devicetree,
> multi-platform-image support (and other key fixes such as syscall restart issues)
> as slap-on patches on top of old code. This is not to avoid any chop-n-dice of
> fixing patches (I've done that in plenty between v1 and v2). Its just that, in
> absence of revision history for ARC port (in upstream later on) - it helps capture
> the evolution of some key features and also for the community it serves as a live
> documentation of bad designs and how they can be fixed.
> 
> Is that a reasonable approach for new port which is non-bisectable anyways ?
> 

Yes, I think that's fine. you should make that clear in the introductory
email though, as well as in the description of any patches that get
changed significantly by a later patch, to make sure people don't comment
on the same things again when you have already fixed them.

	Arnd
