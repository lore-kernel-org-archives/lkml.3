Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3KOW2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:28:09 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49401 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752145Ab3KOW2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:28:05 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: John Stultz <john.stultz@linaro.org>
Cc: Amit Pundir <amit.pundir@linaro.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH v3] epoll: drop EPOLLWAKEUP if PM_SLEEP is disabled
Date: Fri, 15 Nov 2013 23:40:37 +0100
Message-ID: <2338693.sZIlYGM98f@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52866D8D.6070801@linaro.org>
References: <1384500391-20513-1-git-send-email-amit.pundir@linaro.org> <4921878.yXb9shUEsy@vostro.rjw.lan> <52866D8D.6070801@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 15, 2013 10:53:01 AM John Stultz wrote:
> On 11/15/2013 07:10 AM, Rafael J. Wysocki wrote:
> > On Friday, November 15, 2013 12:56:31 PM Amit Pundir wrote:
> >> Drop EPOLLWAKEUP from epoll events mask if CONFIG_PM_SLEEP is disabled.
> >>
> >> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Or am I supposed to take care of this?
> 
> I would assume it would be you, but maybe Al would prefer to take it?
> 
> Also, should this be also marked for stable?

Well, do people see it in production?

Rafael

