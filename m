Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab3BLTmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 14:42:35 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:55234 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161Ab3BLTmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 14:42:33 -0500
Date: Tue, 12 Feb 2013 20:42:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: Should SPARC use cpuidle? (was: linux-next: build failure
	after merge of the final tree (acpi tree related))
Message-ID: <20130212194232.GA15705@merkur.ravnborg.org>
References: <20130211183409.7519b73ca320baeac5ec886f@canb.auug.org.au> <51197D8B.6010407@kernel.org> <20130212173505.GA2155@merkur.ravnborg.org> <511A837B.8020804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511A837B.8020804@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > Do you btw. have any hints how I can convert to the cpu_idle thing you hinted?
> 
> If you have exactly 1 idle state, then cpuidle isn't that interesting,
> except, perhaps the standard residency counters.  If you have multiple
> states to choose from, cpuidle becomes more valuable.
> 
> There are lots of cpuidle users now, including x86's intel_idle,
> processor_idle, and the entire ARM tree.

I think LEON has only a single power-down state.
The APC stuff I know nothing about :-(

So for now I think I will let it be as it is then.

	Sam
