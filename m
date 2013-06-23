Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab3FWVbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:31:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3FWVbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:31:41 -0400
Message-ID: <51C7693B.2050504@suse.cz>
Date: Sun, 23 Jun 2013 23:31:39 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts: Don't run find across mountpoints
References: <51B5F083.1050203@gmail.com>
In-Reply-To: <51B5F083.1050203@gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabriel,

sorry for the late feedback.

Dne 10.6.2013 17:28, Gabriel de Perthuis napsal(a):
> Use RCS_FIND_IGNORE in more places.

Can you split it into two parts - one adding the missing RCS_FIND_IGNORE
to some find invocations, and other adding the -xdev option? While the
first change is obvious, I am in two minds abount the -xdev change. Your
original problem was .git in a separate filesystem, which is dealt with
by RCS_FIND_IGNORE. The actual source tree should  reside in a single
filesystem in any sane setup. OTOH, if somebody really wishes to have
part of the source tree under a separate mountpoint, he probably has a
good reason for this.

Thanks,
Michal
