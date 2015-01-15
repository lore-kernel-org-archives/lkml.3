Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbbAOUYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:24:39 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:53623 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbbAOUYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:24:37 -0500
Date: Thu, 15 Jan 2015 22:24:30 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, David Daney <david.daney@cavium.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Hemmo Nieminen <hemmo.nieminen@iki.fi>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] MIPS: OCTEON: fix kernel crash when offlining a CPU
Message-ID: <20150115202430.GB8087@fuloong-minipc.musicnaut.iki.fi>
References: <1421347767-21740-1-git-send-email-aaro.koskinen@iki.fi>
 <54B816AC.7070902@gmail.com>
 <20150115195345.GA8087@fuloong-minipc.musicnaut.iki.fi>
 <54B81EA0.8060409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B81EA0.8060409@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 15, 2015 at 12:10:08PM -0800, David Daney wrote:
> On 01/15/2015 11:53 AM, Aaro Koskinen wrote:
> >Hi,
> >
> >On Thu, Jan 15, 2015 at 11:36:12AM -0800, David Daney wrote:
> >>On 01/15/2015 10:49 AM, Aaro Koskinen wrote:
> >>>octeon_cpu_disable() will unconditionally enable interrupts when called
> >>>with interrupts disabled. Fix that.
> >>
> >>interrupts are always disabled here, so...
> >
> >Is that also true for all the currently supported stable kernels...?
> 
> I haven't done extensive research recently, but I have removed that pair of
> local_irq_disable/local_irq_enable in our SDK kernel based on 3.10

Ok, I'll add stable tag only for 3.18 as that is the oldest I can test
with at the moment.

A.
