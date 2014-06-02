Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaFBI2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:28:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:43918 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbaFBI2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:28:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,955,1392192000"; 
   d="scan'208";a="541121983"
Date: Mon, 2 Jun 2014 16:28:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [drm] INFO: possible recursive locking detected
Message-ID: <20140602082849.GA10412@localhost>
References: <5388075D.4000809@intel.com>
 <87mwdvhh4c.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mwdvhh4c.fsf@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 11:04:35AM +0300, Jani Nikula wrote:
> On Fri, 30 May 2014, Jet Chen <jet.chen@intel.com> wrote:
> > Hi Jesse,
> >
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> >
> > git://people.freedesktop.org/~jbarnes/linux async-fb-probe
> 
> Do I understand correctly that this is only present in one of Jesse's
> personal branches? The distribution seems quite out of proportion...

Yes, it only happens in Jesse's async-fb-probe branch.  Sorry for CC
more mailing lists than necessary!

Thanks,
Fengguang
