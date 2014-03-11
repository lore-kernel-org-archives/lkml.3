Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaCKK3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:29:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:54889 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbaCKK3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:29:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="489681515"
Date: Tue, 11 Mar 2014 12:36:41 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl-baytrail: add function mux checking in gpio pin
 request
Message-ID: <20140311103641.GX5018@intel.com>
References: <1394114389-27106-1-git-send-email-chiau.ee.chew@intel.com>
 <CACRpkdajaffBOmc9KeUyLkwZth6vNu-Z0Ln+Xf4ZV0gZ9Ytf_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdajaffBOmc9KeUyLkwZth6vNu-Z0Ln+Xf4ZV0gZ9Ytf_g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 11:27:13AM +0100, Linus Walleij wrote:
> On Thu, Mar 6, 2014 at 2:59 PM, Chew Chiau Ee <chiau.ee.chew@intel.com> wrote:
> 
> > From: Chew, Kean Ho <kean.ho.chew@intel.com>
> >
> > The requested gpio pin must has the func_pin_mux field set
> > to GPIO function by BIOS/FW in advanced. Else, the gpio pin
> > request would fail. This is to ensure that we do not expose
> > any gpio pins which shall be used for alternate functions,
> > for eg: wakeup pin, I/O interfaces for LPSS, etc.
> >
> > Signed-off-by: Chew, Kean Ho <kean.ho.chew@intel.com>
> > Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> 
> Patch applied with Darren's ACK.
> 
> This confirms my suspicion that you will not be able to
> hide the pin control interface side of this hardware forever. ;-)
> 
> Mika/Mathias: any comments?

No comments, looks good to me :)
