Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab3GWSuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:50:24 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:41099 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab3GWSuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:50:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130723183841.GA9021@tp>
References: <20130723181606.GA6342@sergelap>
	<20130723183018.GF21100@mtj.dyndns.org>
	<20130723183841.GA9021@tp>
Date: Tue, 23 Jul 2013 14:50:22 -0400
X-Google-Sender-Auth: EMC25Rqr1k9lifeIQ4QONOixIKc
Message-ID: <CAOS58YPynQ-QBx5nZEnYrP5kGTVvv9VAj0cV0aYeikTitvTQbA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] devices cgroup: allow can_attach() if ns_capable
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 2:38 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> This doesn't delegate it into the container.  It allows me, on the host,
> to set the cgroup for a container.

Hmmm? I'm a bit confused. Isn't the description saying that the patch
allows pseudo-root in userns to change cgroup membership even if it
isn't actually root?

Besides, I find the whole check rather bogus and would actually much
prefer just nuking the check and just follow the standard permission
checks.

Thanks.

--
tejun
