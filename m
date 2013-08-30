Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3H3MqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:46:21 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:42623
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752165Ab3H3MqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:46:20 -0400
Date: Fri, 30 Aug 2013 12:46:17 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Make sure to wake reaper
Message-ID: <20130830124617.GA17147@mail.hallyn.com>
References: <20130829211114.GA20726@sergelap>
 <87mwo0xb9p.fsf@xmission.com>
 <20130830011058.GA12720@mail.hallyn.com>
 <87bo4fwyv8.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo4fwyv8.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> The thread_group_leader of any process may not be reaped until all of
> the other threads are dead.  All of the other threads of a
> multi-threaded process self reap when they exit.

Ah, I see.  Thanks.

Then your patch does sound like the safest solution.  Haven't
tested yet (hd failure stands in my way) though I can't see
how it could not fix the bug I was seeing.

-serge
