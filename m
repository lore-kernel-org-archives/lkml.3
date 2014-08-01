Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaHAACn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:02:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:20061 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaHAACm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:02:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,775,1400050800"; 
   d="scan'208";a="570227255"
Date: Fri, 1 Aug 2014 08:02:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LKP <lkp@01.org>, Yuanhan Liu <yuanhan.liu@intel.com>,
        Su Tao <tao.su@intel.com>, Jet Chen <jet.chen@intel.com>
Subject: Re: [x86_64,vsyscall] Kernel panic - not syncing: Attempted to kill
 init! exitcode=0x0000000b
Message-ID: <20140801000207.GB5635@localhost>
References: <20140730142923.GR16537@localhost>
 <CALCETrW2Pygpt8sFWuXtijtcZGxrHcLa8hSFk7ooKvPiU9-M3w@mail.gmail.com>
 <20140730153315.GA29233@localhost>
 <CALCETrXPesCD089zp6JHwaJc=JJb2FBRoFBCUj8DyCr2FjLCNA@mail.gmail.com>
 <20140731110450.GC9455@localhost>
 <CALCETrVuhs+z0Z4j9waMeRvy3zScYHgO_dS4s4bGASJqC76f0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVuhs+z0Z4j9waMeRvy3zScYHgO_dS4s4bGASJqC76f0g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Oops, github needs this link for downloading big files:
> >
> > https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/yocto-minimal-i386.cgz
> 
> Or https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/yocto-minimal-x86_64.cgz,
> I guess?  The particular failure you're seeing here is only possible
> on 64-bit kernels.

You are right. Sorry for the mistake!

Thanks,
Fengguang
