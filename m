Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbaIIQ1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:27:51 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:59421 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaIIQ1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:27:49 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.155]
In-Reply-To: <1410260544-22657-4-git-send-email-yamada.m@jp.panasonic.com>
References: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com> <1410260544-22657-4-git-send-email-yamada.m@jp.panasonic.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 9 Sep 2014 12:27:28 -0400
Message-ID: <CAOFdcFNgLwCEBRDaF7kEjiRj0WR3EKojWo8LjK45LDbBcqtt4Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] kbuild: handle C=... and M=... after entering into
 build directory
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 7:02 AM, Masahiro Yamada
<yamada.m@jp.panasonic.com> wrote:
> This commit avoids processing C=... and M=... twice
> when O=... is also given.
>
> Besides, we can also remove KBUILD_EXTMOD="$(KBUILD_EXTMOD)"
> in the sub-make target.
>
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Acked-by: Peter Foley <pefoley2@pefoley.com>
