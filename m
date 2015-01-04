Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbbADLu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 06:50:58 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59087 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADLu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 06:50:56 -0500
To: rgb@redhat.com
Cc: sgrubb@redhat.com, linux-security-module@vger.kernel.org,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TaskTracker : Simplified thread information tracker.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140927091440.6fe54f43@ivy-bridge>
	<201409280012.FGE05239.VtFOSMOJFOFQLH@I-love.SAKURA.ne.jp>
	<20141007213054.GJ26201@madcap2.tricolour.ca>
	<201410102140.HHB30768.tFVJSFQOMLOOFH@I-love.SAKURA.ne.jp>
	<20141010124923.GD2966@madcap2.tricolour.ca>
In-Reply-To: <20141010124923.GD2966@madcap2.tricolour.ca>
Message-Id: <201501042050.EEH30201.FJVtFHMQOLSFOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 4 Jan 2015 20:50:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Richard Guy Briggs wrote:
> > Richard Guy Briggs wrote:
> > > On 14/09/28, Tetsuo Handa wrote:
> > > > (Q2) Does auxiliary record work with only type=SYSCALL case?
> > > 
> > > Auxiliary records don't work with AUDIT_LOGIN because that record has a
> > > NULL context.  Similarly for core dumps (AUDIT_ANOM_ABEND), AUDIT_SECCOMP,
> > > configuration changes (AUDIT_CONFIG_CHANGE, AUDIT_FEATURE_CHANGE), most
> > > (all?) AUDIT_USER_* messages.
> > > 
> > I see, thank you.
> > 
> > Although I feel that, from the point of view of troubleshooting, emitting
> > history of thread's comm name into NULL-context records would help sysadmin
> > to map login session and operations a user did from that login session,
> > I'm OK with starting history of thread's comm name as auxiliary records
> > (i.e. not emitted into NULL-context records).
> > 
> > Adding LKML for reviewers. What else can I do for merging this patch?
> 
> I'm willing to take it with some reflection and no significant
> objections, in particular from userspace audit.  I'll have a closer look
> at it.
> 
Any comments on this patch?
