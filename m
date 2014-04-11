Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaDKKY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:24:56 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:48733 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbaDKKYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:24:54 -0400
Date: Fri, 11 Apr 2014 06:24:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        Kefeng Wang <kefeng.wang@linaro.org>
Subject: Re: [PATCH] ahci: disable DEVSLP for Intel Valleyview
Message-ID: <20140411102451.GA26252@mtj.dyndns.org>
References: <1397123934-27114-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <5800248.4YbvBlxjQc@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5800248.4YbvBlxjQc@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 12:14:14PM +0200, Bartlomiej Zolnierkiewicz wrote:
> You most likely need to rebase your changes on top of the aforementioned
> patch (Tejun?).

Waiting for -rc1 to drop before applying patches.  I can resolve the
conflict later when applying.  Please go ahead and post the updated
version.

Thanks.

-- 
tejun
