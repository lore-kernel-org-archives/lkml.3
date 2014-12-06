Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaLFLyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 06:54:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:8428 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaLFLyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 06:54:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,529,1413270000"; 
   d="scan'208";a="643437646"
Date: Sat, 6 Dec 2014 13:54:12 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net,
        Will Arthur <will.c.arthur@intel.com>
Subject: Re: Re: [PATCH v9 6/8] tpm: TPM 2.0 baseline support
Message-ID: <20141206115412.GA6618@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1417672518-4530-7-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412050017.40668.PeterHuewe@gmx.de>
 <20141205141303.GF6993@intel.com>
 <trinity-78b59db8-b937-4ee0-989b-557fcbf612db-1417790149807@3capp-gmx-bs52>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <trinity-78b59db8-b937-4ee0-989b-557fcbf612db-1417790149807@3capp-gmx-bs52>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 03:35:49PM +0100, Peter Huewe wrote:
> Hi Jarkko,
>   
> 
> >is it cool if I prepare a separate set of fixes for all issues
> >in v9? I do not see any problem that could not be fixed without
> >major structural changes.
> 
>  
> 
> to be honest - I would prefer a v10 with the fixes included,
> especially since there were quite a few issues/remarks.
> If you already have fixes post them as patches on top of v9 so we
> can test, and then squash them in.

It's as easy for me to just prepare a new patch set.

> I think we are still in schedule if you do fixes over the weekend
> - so we hopefully have a _great_ v10 on monday/tuesday

Yeah, I apologize for the state of v9. I admit that I rushed with it
a bit. I'll prepare a new patch set over the weekend.

> I'll send out the first pull request without TPM2.0 support later
> this evening,
> and then send out another one by next week - this should be fine.

Great!

> The next testing slot is Sunday evening since I'm travelling
> myself (and don't have TPM hardware with me).
>  
>  
> Thanks,
> Peter

/Jarkko
