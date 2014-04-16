Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161275AbaDPN3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:29:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:52795 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161004AbaDPN3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:29:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,872,1389772800"; 
   d="scan'208";a="514170700"
Date: Wed, 16 Apr 2014 06:29:11 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        Kefeng Wang <kefeng.wang@linaro.org>
Subject: Re: [PATCH] ahci: disable DEVSLP for Intel Valleyview
Message-ID: <20140416062911.73971dd7@ultegra>
In-Reply-To: <20140411102451.GA26252@mtj.dyndns.org>
References: <1397123934-27114-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<5800248.4YbvBlxjQc@amdc1032>
	<20140411102451.GA26252@mtj.dyndns.org>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2014 06:24:51 -0400
Tejun Heo <tj@kernel.org> wrote:

> On Fri, Apr 11, 2014 at 12:14:14PM +0200, Bartlomiej Zolnierkiewicz
> wrote:
> > You most likely need to rebase your changes on top of the
> > aforementioned patch (Tejun?).
> 
> Waiting for -rc1 to drop before applying patches.  I can resolve the
> conflict later when applying.  Please go ahead and post the updated
> version.
> 
Just posted v2 with suggestions from Bartlomiej. 

Thanks,

Jacob
