Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3LVVIc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 16:08:32 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57452 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753296Ab3LVVIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 16:08:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Vince Weaver <vince@deater.net>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Gavin Hindman <gavin.hindman@intel.com>,
        "Triplett, Josh" <josh.triplett@intel.com>
Subject: Re: [PATCH] powercap/rapl: add support for ValleyView Soc
Date: Sun, 22 Dec 2013 22:21:55 +0100
Message-ID: <3683372.O2J0Fy185V@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.02.1312221420400.13165@pianoman.cluster.toy>
References: <1386801567-26661-1-git-send-email-jacob.jun.pan@linux.intel.com> <1553570.ISCzPqBYzN@vostro.rjw.lan> <alpine.DEB.2.02.1312221420400.13165@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 22, 2013 02:22:48 PM Vince Weaver wrote:
> On Sun, 22 Dec 2013, Rafael J. Wysocki wrote:
> > On Wednesday, December 11, 2013 02:39:27 PM Jacob Pan wrote:
> 
> > > @@ -941,6 +949,7 @@ static void package_power_limit_irq_restore(int package_id)
> > >  static const struct x86_cpu_id rapl_ids[] = {
> > >  	{ X86_VENDOR_INTEL, 6, 0x2a},/* SNB */
> > >  	{ X86_VENDOR_INTEL, 6, 0x2d},/* SNB EP */
> > > +	{ X86_VENDOR_INTEL, 6, 0x37},/* VLV */
> > >  	{ X86_VENDOR_INTEL, 6, 0x3a},/* IVB */
> > >  	{ X86_VENDOR_INTEL, 6, 0x45},/* HSW */
> > >  	/* TODO: Add more CPU IDs after testing */
> 
> This isn't a problem introduced in this patch, but it made me notice it...
> 
> Would it really hurt anyone to spell out the architectures here, rather
> than using obscure 3-letter abbreviations?  It's bad enough trying to
> map the hex model numbers to the decimal ones in /proc/cpuinfo without
> also having to remember what a VLV is.

I guess you can prepare a patch for that?

Rafael

