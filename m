Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3KFTo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:44:26 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52168 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab3KFToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:44:24 -0500
MIME-Version: 1.0
In-Reply-To: <1383766098.21999.2.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1383753106-26978-1-git-send-email-avagin@openvz.org>
	<527A9638.4020404@redhat.com>
	<1383766098.21999.2.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Wed, 6 Nov 2013 11:44:23 -0800
Message-ID: <CAMEtUuz51grUwaz+qzpmGLENx5WFJoMs0WuU2UMN8cmUoPpShg@mail.gmail.com>
Subject: Re: [PATCH] net: don't forget to free sk_filter
From: Alexei Starovoitov <ast@plumgrid.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, Andrey Vagin <avagin@openvz.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 11:28 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Actually, the new way [1] of doing this would be to use the 'Fixes:' tag
> as in :
>
> Fixes: <12 digits SHA1> ("net: fix unsafe set_memory_rw from softirq")
>
> [1] As discussed at last Kernel Summit

thx. good to know.
Unfortunately 2013 Kernel Summit proceedings are not public (yet?),
but available to paid LWN subscribers.
