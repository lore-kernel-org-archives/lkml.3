Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab3COHSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:18:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48669 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab3COHSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:18:35 -0400
Date: Fri, 15 Mar 2013 08:18:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>, Tony Luck <tony.luck@intel.com>,
        "Mark A. Grondona" <mgrondona@llnl.gov>,
        Robert Richter <rric@kernel.org>
Subject: Re: [ANNOUNCE] rasdaemon userspace tool v.0.1
Message-ID: <20130315071828.GA13775@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <srostedt@redhat.com>,
	Tony Luck <tony.luck@intel.com>,
	"Mark A. Grondona" <mgrondona@llnl.gov>,
	Robert Richter <rric@kernel.org>
References: <20130314153844.158d817c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130314153844.158d817c@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 03:38:44PM -0300, Mauro Carvalho Chehab wrote:
> It is still on my TODO list to add a RAS trace event for non-memory
> related errors that come via the MCA machine check handler (mcelog).

That's already there: trace_mce_record.

> While progress made was made at Kernel infrastructure, the needed
> userspace tools were still lacking. So, I decided to start
> materializing the userspace counterpart for what it was informally
> named as rasdaemon on some discussions.

Well, I had RAS daemon long before you did:
http://marc.info/?l=linux-kernel&m=130357637429355&w=2

And Robert and I have recently restarted work on it so having two
different RAS daemons will be confusing to people. You probably could
call it "hermd" or "errord" or something better you can come up with.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
