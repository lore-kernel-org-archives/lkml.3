Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3F0Swf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:52:35 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:56424 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3F0Swd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130627185104.GA2018@sergelap>
References: <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
	<CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
	<20130625000118.GT1918@mtj.dyndns.org>
	<CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
	<20130626212047.GB4536@htj.dyndns.org>
	<1372311907.5871.78.camel@marge.simpson.net>
	<20130627132206.GE4003@sergelap>
	<20130627174850.GC5599@mtj.dyndns.org>
	<20130627181457.GB26334@sergelap>
	<20130627184541.GA6400@mtj.dyndns.org>
	<20130627185104.GA2018@sergelap>
Date: Thu, 27 Jun 2013 11:52:32 -0700
X-Google-Sender-Auth: PieL9QS5k6BJz7BouoW9yNc_8Xk
Message-ID: <CAOS58YNSCkS=5xiJZSq+=CFEYUE2kyn5dpbPSCViB4=+hQKx3A@mail.gmail.com>
Subject: Re: cgroup: status-quo and userland efforts
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Mike Galbraith <bitbucket@online.de>, Tim Hockin <thockin@hockin.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        jpoimboe <jpoimboe@redhat.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 27, 2013 at 11:51 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
>> I think it probably would be better to allow organization and RO
>
> What do you mean by "organization"?  Creating cgroups and moving tasks
> between them, without setting other cgroup values?

Yeap, I also think that's how user sessions are gonna be handled.
We're gonna have limited amount of delegation for organization and
read accesses.

Thanks.

--
tejun
