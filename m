Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3CTOoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:44:37 -0400
Received: from mail.digium.com ([216.207.245.2]:44681 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab3CTOof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:44:35 -0400
X-Greylist: delayed 1204 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 10:44:35 EDT
Date: Wed, 20 Mar 2013 09:24:44 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [3.9-rc1] Bug in bootup code or debug code?
Message-ID: <20130320142444.GA10492@digium.com>
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp>
 <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp>
 <201303132224.BEC60922.JStQOFMVFFOHLO@I-love.SAKURA.ne.jp>
 <3E5A0FA7E9CA944F9D5414FEC6C71220528C2DFF@ORSMSX105.amr.corp.intel.com>
 <5140BB13.10806@linux.intel.com>
 <201303140545.DAC69253.FtSJOOFMHVFOLQ@I-love.SAKURA.ne.jp>
 <3E5A0FA7E9CA944F9D5414FEC6C7122055946F23@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122055946F23@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:12:39PM +0000, Yu, Fenghua wrote:
> > From: Tetsuo Handa [mailto:penguin-kernel@I-love.SAKURA.ne.jp]
> > H. Peter Anvin wrote:
> > > This is a CONFIG_DEBUG_VIRTUAL configuration, isn't it?
> > 
> > Yes. CONFIG_MICROCODE_INTEL_EARLY=y && CONFIG_64BIT=n &&
> > CONFIG_DEBUG_VIRTUAL=y
> > on VMware Workstation/Player environment.
> 
> Tetsuo,
> 
> I just now sent out a patch to fix this issue and you are in the list.
> 
> Could you please verify if it fixes the issue you saw?

Hi Fenghua,

I ran into the same issue on a test system I use (not a virtual
machine) and went through basically the same process as Dave
Hansen w/bisecting before finding this thread.

Any chance you could send the patch to the mailing list and I could
also throw it on my test system?

Thanks,
Shaun
