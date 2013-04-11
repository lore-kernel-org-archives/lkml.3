Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936076Ab3DKOgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:36:33 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:52580 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765117Ab3DKOgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:36:32 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <51669BEA.4060808@parallels.com>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
	<51669BEA.4060808@parallels.com>
Date: Thu, 11 Apr 2013 16:36:30 +0200
Message-ID: <CAJfpegtoeVxUPaAyLQAnMykU0pkr3N4eRSR7pWRVm46TKotX9Q@mail.gmail.com>
Subject: Re: [fuse-devel] [PATCH v4 00/14] fuse: An attempt to implement a
 write-back cache policy
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jbottomley@parallels.com,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 1:18 PM, Maxim V. Patlasov
<mpatlasov@parallels.com> wrote:
>
> Any feedback would be highly appreciated.

I was reviewing the patchset but that got delayed by a few weeks due
to various things.

On the whole it looks good, and I'll try to push it for 3.10.

Thanks,
Miklos
