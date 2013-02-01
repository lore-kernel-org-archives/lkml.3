Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab3BAC2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 21:28:40 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:43657 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3BAC2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 21:28:36 -0500
Date: Thu, 31 Jan 2013 18:28:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kbuild test robot <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel/cgroup_freezer.c:151:3: error: 'system_freezing_cnt'
 undeclared
Message-ID: <20130201022816.GR6824@mtj.dyndns.org>
References: <510aa746.fVU8ZdQ2hys/RwjS%fengguang.wu@intel.com>
 <20130131231433.GM6824@mtj.dyndns.org>
 <510B1051.5010200@tilera.com>
 <20130201005225.GQ6824@mtj.dyndns.org>
 <510B270C.5000603@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510B270C.5000603@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 09:23:08PM -0500, Chris Metcalf wrote:
> On 1/31/2013 7:52 PM, Tejun Heo wrote:
> > Hello, Chris.
> >
> > On Thu, Jan 31, 2013 at 07:46:09PM -0500, Chris Metcalf wrote:
> >> That seems reasonable to me, but I'm happy to experiment with
> >> including Kconfig.freezer from the arch/tile/Kconfig if that feels
> >> like a better solution.
> > AFAICS, there's nothing arch specific about freezer and cgroup_freezer
> > could be useful even without powersaving, so maybe give it a shot?
> 
> It builds with the following change.  Look good to you?

Yeap, thanks!

-- 
tejun
