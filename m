Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096AbaLPR07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 12:26:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:2303 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaLPR06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 12:26:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="499642234"
Date: Tue, 16 Dec 2014 09:15:28 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        "Zijlstra, Peter" <peter.zijlstra@intel.com>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
Message-ID: <20141216091528.17ee429d@ultegra>
In-Reply-To: <CAKohpokZCK3TAZx1mwo3zLxugkxg-h7MAXkTxA4LVWausufDYg@mail.gmail.com>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com>
	<CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
	<548E8D01.9050707@linux.vnet.ibm.com>
	<CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
	<548EAD4A.6070506@linux.vnet.ibm.com>
	<DD415AA12F8FF042BF4EA69DF123C1478AF76532@ORSMSX106.amr.corp.intel.com>
	<CAKohpokZCK3TAZx1mwo3zLxugkxg-h7MAXkTxA4LVWausufDYg@mail.gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014 09:48:42 +0530
Viresh Kumar <viresh.kumar@linaro.org> wrote:

> On 16 December 2014 at 02:54, Pan, Jacob jun
> <jacob.jun.pan@intel.com> wrote:
> 
> > Looks good to me. You can add my Reviewed-by to the above patch.
> 
> Thanks.
> 
> > I have tested this fix and confirm powerclamp is working properly
> > now.
> 
> Oh, nice.
> 
> > However, we also have a planned patch for consolidated idle loop.
> > With this patch it causes some erratic behavior in idle injection.
> > I can’t seem to synchronize/align idle time around jiffies with
> > this patch + fix.
> >
> > Any suggestions welcome.
> > https://lkml.org/lkml/2014/6/4/56
> 
> And all works fine without this patch ?
well, there are other things i need to improve. but this patch
definitely causes some new unwanted behavior.
> 2a16fc93d2c9 ("nohz: Avoid tick's double reprogramming in highres
> mode")
> 
> I really don't know what stuff out of the two patches I posted (The
> above one and the fix I posted yesterday), will possible make the
> synchronization bad ..
> 
But since your patch has real benefits and does not cause regression
with the current code, there is no reason to hold it back. I was just
hoping to get help on debugging this.

thanks,

Jacob
> --
> viresh
