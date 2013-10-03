Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3JCHee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 03:34:34 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:40582 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3JCHed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 03:34:33 -0400
Date: Thu, 3 Oct 2013 09:34:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [QUERY] Why does perf-trace need me to be root?
Message-ID: <20131003073429.GD5775@gmail.com>
References: <CALkWK0mmUZe-Wv2H2Z3y9FN0_kYv9gKaaXkMQ0UD-J9Q+=wFzQ@mail.gmail.com>
 <524C1964.8090205@gmail.com>
 <CALkWK0kzXnBKiRyN5HPE-_nScOG-JKjAnD1ujxA_R8tWQWrxZQ@mail.gmail.com>
 <20131003062505.GE25345@gmail.com>
 <CALkWK0ku=fFpQkd6r6DhwVAALpfgA8K-JkTjLJqSf0y-ysmmkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkWK0ku=fFpQkd6r6DhwVAALpfgA8K-JkTjLJqSf0y-ysmmkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> Ingo Molnar wrote:
> >    echo 'kernel.perf_event_paranoid = -1' >> /etc/sysctl.conf
> 
> Thanks Ingo. It's called /etc/sysctl.d/* now:
> https://www.archlinux.org/news/deprecation-of-etcsysctlconf/

That works too, on modern distros.

Thanks,

	Ingo
