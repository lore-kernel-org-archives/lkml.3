Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750953AbaLPESo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:18:44 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:56078 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLPESn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:18:43 -0500
MIME-Version: 1.0
In-Reply-To: <DD415AA12F8FF042BF4EA69DF123C1478AF76532@ORSMSX106.amr.corp.intel.com>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com>
	<CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
	<548E8D01.9050707@linux.vnet.ibm.com>
	<CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
	<548EAD4A.6070506@linux.vnet.ibm.com>
	<DD415AA12F8FF042BF4EA69DF123C1478AF76532@ORSMSX106.amr.corp.intel.com>
Date: Tue, 16 Dec 2014 09:48:42 +0530
Message-ID: <CAKohpokZCK3TAZx1mwo3zLxugkxg-h7MAXkTxA4LVWausufDYg@mail.gmail.com>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>,
        "Jacob Pan (jacob.jun.pan@linux.intel.com)" 
	<jacob.jun.pan@linux.intel.com>,
        "Zijlstra, Peter" <peter.zijlstra@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2014 at 02:54, Pan, Jacob jun <jacob.jun.pan@intel.com> wrote:

> Looks good to me. You can add my Reviewed-by to the above patch.

Thanks.

> I have tested this fix and confirm powerclamp is working properly now.

Oh, nice.

> However, we also have a planned patch for consolidated idle loop. With this patch it causes some erratic behavior in idle injection.
> I can’t seem to synchronize/align idle time around jiffies with this patch + fix.
>
> Any suggestions welcome.
> https://lkml.org/lkml/2014/6/4/56

And all works fine without this patch ?
2a16fc93d2c9 ("nohz: Avoid tick's double reprogramming in highres mode")

I really don't know what stuff out of the two patches I posted (The above one
and the fix I posted yesterday), will possible make the synchronization bad ..

--
viresh
