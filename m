Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3G3ToQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:44:16 -0400
Received: from plane.gmane.org ([80.91.229.3]:38798 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3G3ToP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:44:15 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ilari Stenroth <ilari.stenroth@gmail.com>
Subject: Re: arch/x86/kernel/cpu/intel.c needs an update for Haswell?
Date: Tue, 30 Jul 2013 22:44:02 +0300
Message-ID: <kt951r$m5m$1@ger.gmane.org>
References: <kt91u2$jhs$1@ger.gmane.org> <20130730193530.GB23299@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: gw.stenroth.fi
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
In-Reply-To: <20130730193530.GB23299@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.7.2013 22.35, Borislav Petkov wrote:
> On Tue, Jul 30, 2013 at 09:50:49PM +0300, Ilari Stenroth wrote:
>> Does somebody know why arch/x86/kernel/cpu/intel.c has
>> tlb_flushall_shift detection logic for Ivy Bridge CPU family but not
>> for Haswell? Maybe intel_cacheinfo.c needs to be checked for Haswell
>> updates too.
> 
> Because someone needs to sit down and write it. Oh, and more
> importantly, test it on real hardware.
> 
> :-)
> 

Right :-) Can volunteer to test, only once I get a motherboard bug
fixed. It runs only one core. Poor Supermicro X10SLH-F thinks Xeon
E3-1265Lv3 has 1C2T :-/

Regs,
Ilari Stenroth


