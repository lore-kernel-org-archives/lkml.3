Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933711AbaJUWab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:30:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933387AbaJUWaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:30:30 -0400
From: Paul Moore <pmoore@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, serge@hallyn.com, keescook@chromium.org
Subject: Re: [RFC][PATCH] audit: log join and part events to the read-only multicast log socket
Date: Tue, 21 Oct 2014 18:30:24 -0400
Message-ID: <1645943.LlOpH1gJUB@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <2131923.Byl8GhZuQt@x2>
References: <30ef5c1ba42b52953e5684a0322975c3f0fadc77.1412706089.git.rgb@redhat.com> <1412708594.3333.94.camel@localhost> <2131923.Byl8GhZuQt@x2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 21, 2014 03:56:10 PM Steve Grubb wrote:
> audit_log_task_info logs too much information for typical use. There are
> times when you might want to know everything about what's connecting. But
> in this case, we don't need anything about groups, saved uids, fsuid, or
> ppid.
> 
> Its a shame we don't have a audit_log_task_info_light function which only
> records:
> 
> pid= auid= uid= subj= comm= exe=  ses= tty=

This is getting back to my earlier concerns/questions about field ordering, or 
at the very least I'm going to hijack this conversation and steer it towards 
field ordering ;)

Before we go to much farther, I'd really like us to agree that ordering is not 
important, can we do that?  As a follow up, what do we need to do to make that 
happen in the userspace tools?

-- 
paul moore
security and virtualization @ redhat

