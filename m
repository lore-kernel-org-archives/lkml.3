Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbaLQA0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 19:26:40 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40679 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaLQA0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 19:26:39 -0500
Date: Wed, 17 Dec 2014 01:26:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
Message-ID: <20141217002635.GB19459@lerouge>
References: <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
 <20141215234443.GA23297@lerouge>
 <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com>
 <548FFD20.1040102@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1412161105470.17382@nanos>
 <20141216142029.GA27375@lerouge>
 <alpine.DEB.2.11.1412161533210.17382@nanos>
 <alpine.DEB.2.11.1412161802570.17382@nanos>
 <20141216224903.GS3219@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1412162350110.17382@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412162350110.17382@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 11:54:51PM +0100, Thomas Gleixner wrote:
> > But yes, that should work just fine..
> 
> So I'm not the only one who thinks that this needs a proper
> reimplementation :)

Besides, if this works, we'll have way less IPIs, and people
usually like that :-)
