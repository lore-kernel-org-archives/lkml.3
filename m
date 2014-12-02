Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbaLBRRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:17:14 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:44840 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaLBRRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:17:13 -0500
Date: Tue, 2 Dec 2014 09:17:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202171704.GA27174@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
 <20141127225637.GA24019@redhat.com>
 <m5dart$co$1@ger.gmane.org>
 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547D7B05.6080403@cn.fujitsu.com>
 <547defc3.28568c0a.73eb.1a1e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547defc3.28568c0a.73eb.1a1e@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120217-8236-0000-0000-000007649BBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 02:58:38PM -0200, Dâniel Fraga wrote:
> On Tue, 2 Dec 2014 16:40:37 +0800
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > It is needed at lest for testing.
> > 
> > CONFIG_TREE_PREEMPT_RCU=y with CONFIG_PREEMPT=n is needed for testing too.
> > 
> > Please enable them (or enable them under CONFIG_RCU_TRACE=y)
> 
> 	Lai, sorry but I didn't understand. Do you mean both of them
> enabled? Because how can CONFIG_TREE_PREEMPT_RCU be enabled without
> CONFIG_PREEMPT ?

Hmmm...  I did misread that in my reply.  A similar Kconfig edit will
enable that, but I am even less happy about the thought of pushing that
to mainline!  ;-)

							Thanx, Paul

> 	If you mean both enabled, I already reported a call trace with
> both enabled:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=85941
> 
> 	Please see my previous answer to Linus and Paul too.
> 
> 	Regarding CONFIG_RCU_TRACE, do you mean
> "CONFIG_TREE_RCU_TRACE"? I couldn't find CONFIG_RCU_TRACE.
> 
> 	Thanks.
> 
> -- 
> Linux 3.17.0-dirty: Shuffling Zombie Juror
> http://www.youtube.com/DanielFragaBR
> http://exchangewar.info
> Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
> 

