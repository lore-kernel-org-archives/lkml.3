Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbbA0V6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:58:20 -0500
Received: from relais.videotron.ca ([24.201.245.36]:56987 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759484AbbA0V6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:58:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 27 Jan 2015 16:58:17 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Rob Herring <robherring2@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
In-reply-to: <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr>
Message-id: <alpine.LFD.2.11.1501271644570.1322@knanqh.ubzr>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <20150127132127.GA869@amd>
 <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
 <201501271532.25540@pali> <20150127174818.GM26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271446330.1322@knanqh.ubzr>
 <20150127210943.GN26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Nicolas Pitre wrote:

> If there is indeed a sizable following for the device then someone 
> should figure out how to cope with upstream kernels, either through the 
> installation of some intermediate bootloader that can talk FDT directly, 
> or via a shim layer.  None of that has to be performed by nor linked 
> with the kernel binary, nor maintained in the kernel tree. And it's not 
> even that hard to do: we have precedents on other platforms with crappy 
> bootloaders where this just works.

For reference I recommend the following threads:

http://comments.gmane.org/gmane.linux.kbuild.devel/10722

http://www.spinics.net/lists/arm-kernel/msg249719.html


Nicolas
