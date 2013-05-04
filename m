Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761757Ab3EDUjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 16:39:22 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:51301 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab3EDUjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 16:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <85487641.pdFCOjE3G7@vostro.rjw.lan>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
	<1367458508-9133-11-git-send-email-ccross@android.com>
	<20130503000812.GY19814@mtj.dyndns.org>
	<85487641.pdFCOjE3G7@vostro.rjw.lan>
Date: Sat, 4 May 2013 13:39:19 -0700
X-Google-Sender-Auth: JgT07r1x_dduR6GAZJn5aW-B4co
Message-ID: <CAOS58YO2b=zFGUVqrV1dHV6gDouNJpN2Wnwo_D6f5V7G9Wz9Vg@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] af_unix: use freezable blocking calls in read
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Colin Cross <ccross@android.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arve@android.com,
        Oleg Nesterov <oleg@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Sat, May 4, 2013 at 12:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> Heh, so you are aware of the deadlock possibilities.  Good selection
>> of spots.  For all the conversion patches.
>>
>>  Acked-by: Tejun Heo <tj@kernel.org>
>
> I wonder if that includes [3/10] (just to get the record straight)?

I think we want the lockdep annotations before these go in. I'll
review Colin's new series later today.

Thanks!

--
tejun
