Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaI3Ll7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:41:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:24800 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaI3Ll6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:41:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,626,1406617200"; 
   d="scan'208";a="581197191"
Date: Tue, 30 Sep 2014 19:41:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [torture] BUG: unable to handle kernel NULL pointer dereference
 at (null)
Message-ID: <20140930114138.GA3974@wfg-t540p.sh.intel.com>
References: <20140913122412.GA10984@localhost>
 <20140915202710.GG4723@linux.vnet.ibm.com>
 <20140917023154.GA9519@localhost>
 <20140917161704.GZ4723@linux.vnet.ibm.com>
 <20140918131751.GA8797@localhost>
 <20140926074223.GN4723@linux.vnet.ibm.com>
 <20140930022740.GA4723@wfg-t540p.sh.intel.com>
 <20140930095842.GR5015@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930095842.GR5015@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> One thing would be something like this:
> 
> 	( sleep 300; rmmod rcutorture ) &
> 
> Running both locktorture and rcutorture concurrently is not supported
> at the moment because both make the assumption that they have the entire
> system at their disposal.

It's good to know that! Following your instructions, I just added 2
test cases for rcutorture and locktorture in LKP. :)

Thanks,
Fengguang
