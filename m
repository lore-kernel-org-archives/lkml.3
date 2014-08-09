Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbaHIEwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 00:52:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:19613 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaHIEwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 00:52:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,830,1400050800"; 
   d="scan'208";a="574075444"
Date: Sat, 9 Aug 2014 12:52:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Marcel Holtmann <marcel@holtmann.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [rfcomm] WARNING: CPU: 0 PID: 105 at kernel/sched/core.c:7094
 __might_sleep()
Message-ID: <20140809045244.GA22456@localhost>
References: <20140805140726.GC5593@localhost>
 <CAPDOMVidvibruAOqYF9OHc9S4M-e081hegPerg7Ehb38p-PqBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVidvibruAOqYF9OHc9S4M-e081hegPerg7Ehb38p-PqBw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

> Fenguang,
> Just asking , is this a new trace or are you reminding our or another
> older trace you did a few months
> back. If it isn't I will be glad to trace this for you and the maintainers.
> Regards Nick

It's a new trace. However should be an old problem newly disposed by
Peter's debug patch.

Thanks,
Fengguang
