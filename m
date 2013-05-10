Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3EJNBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:01:50 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:42821 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab3EJNBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:01:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, linux-acpi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, boinc_dev@ssl.berkeley.edu
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost ACPI functionality
Date: Fri, 10 May 2013 15:10:12 +0200
Message-ID: <4720627.g9zHkFYIDJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5184BF82.4070700@gmx.de>
References: <5183EC09.9080208@gmx.de> <51842F6F.1050005@intel.com> <5184BF82.4070700@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 04, 2013 09:57:54 AM Toralf Förster wrote:
> On 05/03/2013 11:43 PM, Dirk Brandewie wrote:
> > On 05/03/2013 02:26 PM, Toralf Förster wrote:
> >> On 05/03/2013 11:10 PM, Dirk Brandewie wrote:
> >>>
> >>> ignore_nice_load is a feature of the ondemand governor.
> >>> The intel_pstate driver is seeing the load presented by the BOINC client
> >>> and is adjusting the pstate accordingly.
> >>
> >> Is the intel_pstate driver a choice for a notebook and friends where a
> >> grid software is running as a low-prio back ground job ?
> >>
> > 
> > Probably not.
> 
> Hhm.
> 
> The kernel menuconfig says :
> 
>  This driver provides a P state for Intel core processors
>  The driver implements an internal governor and will become
>  the scaling driver and governor for Sandy bridge processors.
> 
> 
> What shall a company like IBM with a lot of notebook installation running BOINC
> in the back ground process (World Community Grid) do - what's the consequence for
> those installations if they will have that a processor ?
> 
> In the past (few years ago and related to the ondemand governor IIRC) there were
> already a longer discussion about the "nice -n 19" topic and the result was
> to support it.
> 
> /me Cc:'ing boinc devs, the topic might be interesting for them too.

One option might be to use the powerclamp driver along with intel_pstate to
reduce the heat dissipation.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
