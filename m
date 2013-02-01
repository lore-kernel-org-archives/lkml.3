Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3BAAwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 19:52:39 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44350 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3BAAwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 19:52:36 -0500
Date: Thu, 31 Jan 2013 16:52:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kbuild test robot <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel/cgroup_freezer.c:151:3: error: 'system_freezing_cnt'
 undeclared
Message-ID: <20130201005225.GQ6824@mtj.dyndns.org>
References: <510aa746.fVU8ZdQ2hys/RwjS%fengguang.wu@intel.com>
 <20130131231433.GM6824@mtj.dyndns.org>
 <510B1051.5010200@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510B1051.5010200@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Chris.

On Thu, Jan 31, 2013 at 07:46:09PM -0500, Chris Metcalf wrote:
> That seems reasonable to me, but I'm happy to experiment with
> including Kconfig.freezer from the arch/tile/Kconfig if that feels
> like a better solution.

AFAICS, there's nothing arch specific about freezer and cgroup_freezer
could be useful even without powersaving, so maybe give it a shot?

Thanks.

-- 
tejun
