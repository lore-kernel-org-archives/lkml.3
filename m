Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaKGNHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:07:42 -0500
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:52980 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaKGNHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:07:25 -0500
Date: Fri, 7 Nov 2014 22:07:17 +0900
From: Norbert Preining <preining@logic.at>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
Message-ID: <20141107130717.GF11838@auth.logic.tuwien.ac.at>
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at>
 <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com>
 <20141105001026.GQ13232@auth.logic.tuwien.ac.at>
 <20141105001243.GR13232@auth.logic.tuwien.ac.at>
 <alpine.DEB.2.10.1411041615270.5391@chino.kir.corp.google.com>
 <545B68C9.2060107@suse.cz>
 <20141106123904.GU11838@auth.logic.tuwien.ac.at>
 <545B71A8.6030209@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B71A8.6030209@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vlastimil,

On Thu, 06 Nov 2014, Vlastimil Babka wrote:
> OK, one possibility is to do (it should apply cleanly)
> git revert e14c720efdd73c6d69cd8d07fa894bcd11fe1973

I am running with this reverted now, and I cannot reproduce the
khugepage going overboard anymore.

I tried hard since 2 days now, no chance to reproduce.
Before firefox or shotwell went into boom mode, but not now.
(For now!)

> > Again, as I mentioned, I don't have /proc/pid/stack for any "pid", is
> > this depending on some specific kerenl option?
> 
> Ah I missed that. Should be CONFIG_STACKTRACE to enable that.

If you want, I can compile a "default" kernel without the above commit
reverted, and turn on STACKTRACE (I have turned it one for *all* future
kernels I compile ;-)

I also didn't try the patch you send me, just the revert from above.

Please let me know which other experiments you want to see.

Thanks

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
