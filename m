Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3CTSeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:34:12 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42398 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3CTSeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:34:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130320.134352.637366236022186710.davem@davemloft.net>
References: <1363800536-3615-1-git-send-email-dbaluta@ixiacom.com>
	<20130320.134251.915716656509401204.davem@davemloft.net>
	<20130320.134352.637366236022186710.davem@davemloft.net>
Date: Wed, 20 Mar 2013 20:34:07 +0200
X-Google-Sender-Auth: zs2JovWNaoy4Lb5EKLopOKt8e3s
Message-ID: <CAEnQRZCYv=r_uB9pw=pMDEMSWAbsa7mHdjvB1uKfb8PKF4tyGw@mail.gmail.com>
Subject: Re: [PATCH] net: fix psock_fanout selftest bind error message
From: Daniel Baluta <dbaluta@ixiacom.com>
To: David Miller <davem@davemloft.net>
Cc: willemb@google.com, edumazet@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 7:43 PM, David Miller <davem@davemloft.net> wrote:
>
> Please, in the future, post networking patches to netdev@vger.kernel.org
> rather than lkml.

Sure, I was convinced that I did that. get_maintainer.pl is playing
tricks on me :)

$ ./scripts/get_maintainer.pl
0001-net-fix-psock_fanout-selftest-bind-error-message.patch
"David S. Miller" <davem@davemloft.net> (commit_signer:4/4=100%)
Willem de Bruijn <willemb@google.com> (commit_signer:2/4=50%)
Daniel Baluta <dbaluta@ixiacom.com> (commit_signer:1/4=25%)
Eric Dumazet <edumazet@google.com> (commit_signer:1/4=25%)
linux-kernel@vger.kernel.org (open list)

thanks,
Daniel.
