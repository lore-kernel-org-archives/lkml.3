Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763620Ab3ECV0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:26:23 -0400
Received: from mout.gmx.net ([212.227.15.15]:56292 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761179Ab3ECV0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:26:21 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/xyOYGi/bxlGGHqWHOP/jCeYBM9CFd2T185XZVow
	ta4Ld9HhB1j6+G
Message-ID: <51842B79.8060302@gmx.de>
Date: Fri, 03 May 2013 23:26:17 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130405 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan> <518427D4.3050104@gmail.com>
In-Reply-To: <518427D4.3050104@gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 11:10 PM, Dirk Brandewie wrote:
> 
> ignore_nice_load is a feature of the ondemand governor.
> The intel_pstate driver is seeing the load presented by the BOINC client
> and is adjusting the pstate accordingly.

Is the intel_pstate driver a choice for a notebook and friends where a
grid software is running as a low-prio back ground job ?

Because the CPU will be running mostly at high(er) frequency - which
always results in a high temperature and short battery time.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
