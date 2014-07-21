Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484AbaGUSoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:44:21 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:48208 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237AbaGUSoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:44:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140721183322.GA29601@mtj.dyndns.org>
References: <20140721121740.GB12921@htj.dyndns.org>
	<CA+55aFwzZoef-fXj1D57N9ywxWBF0bj2cWgOQMQDLM=NAH7hrA@mail.gmail.com>
	<20140721183322.GA29601@mtj.dyndns.org>
Date: Mon, 21 Jul 2014 11:44:15 -0700
X-Google-Sender-Auth: 1I3nulKsqDZxIvYlwdDaiZ9-I-4
Message-ID: <CA+55aFwjt8BhmKVnMbFfcVG7NJpkeCV+N5y3KOeiDg8sTGSbww@mail.gmail.com>
Subject: Re: [GIT PULL] libata fixes for v3.16-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:33 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Urgh... sorry about that.  This is the same git-request-pull problem
> that occurred the last time.  I forgot adding cc:stable to the last
> patch and force-pushed that out before generating the pull request (I
> had it sitting in my local branch for some days) and git-request-pull
> dropped the branch name because the commit IDs of local and remote
> disagreed.  git --version says 1.9.3.  Maybe it's not fixed in this
> version yet?

So git 2.0 should have the fix where it complains loudly if it cannot
find things instead of leaving things empty. It's probably not in
1.9.3.

           Linus
