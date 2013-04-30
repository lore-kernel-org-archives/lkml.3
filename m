Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736Ab3D3O7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:59:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab3D3O7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:59:20 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BTRBD928usAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=YPD5nf4ZmOMA:10 a=NkMT6FMz6JdvkBJta2UA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367333957.30667.61.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.4.41-rt55-feat3
From: Steven Rostedt <rostedt@goodmis.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 30 Apr 2013 10:59:17 -0400
In-Reply-To: <2805818.g7STVSuEne@dabox>
References: <1367283987.30667.49.camel@gandalf.local.home>
	 <2805818.g7STVSuEne@dabox>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-30 at 11:14 +0200, Tim Sander wrote:
> Hi Steve and all RT Folks
> 
> > I'm pleased to announce the 3.4.41-rt55-feat3 feature release.
> > 
> > Note, I first uploaded -feat2 then realized I didn't add a compile fix by
> > Mike Galbraith, and then created the -feat3 with that fix.
> I just wanted to say thanks that this patch enables compilation again with the 
> preempt rt patchset with CONFIG_HIGH_RES_TIMERS disabled :-). 
> I think this patch* should be moved out of the feat patchset into the stable 
> rt backport branch as this also doesn't compile beginning with the 3.6.36-rt50 
> patch with CONFIG_HIGH_RES_TIMERS disabled .

As the discussion was originally in the -feat thread, I didn't realize
it was required for vanilla. Hmm, as it had nothing to do with softirqs
I should have realized that. Oh well.

Anyway, I'm working on getting the mainline stable releases merged into
the current stable-rt releases, and then I'll be looking at backports
from upstream -rt. I'll add it then.

-- Steve


