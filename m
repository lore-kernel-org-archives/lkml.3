Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbaIIQZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:25:50 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45125 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaIIQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:25:48 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.155]
In-Reply-To: <1410260544-22657-3-git-send-email-yamada.m@jp.panasonic.com>
References: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com> <1410260544-22657-3-git-send-email-yamada.m@jp.panasonic.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 9 Sep 2014 12:25:27 -0400
Message-ID: <CAOFdcFN3Y9SdJzhgm3bHPVA_pXJLuHVoMKTbtSNbq+p0HsdMyQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] kbuild: use $(Q) for sub-make target
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 7:02 AM, Masahiro Yamada
<yamada.m@jp.panasonic.com> wrote:
> Since commit 066b7ed9558087a7957a1128f27d7a3462ff117f
> (kbuild: Do not print the build directory with make -s),
> "Q" is defined above the sub-make target.
>
> This commit takes advantage of that and replaces
> "$(if $(KBUILD_VERBOSE:1=),@)" with "$(Q)".
>
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Acked-by: Peter Foley <pefoley2@pefoley.com>
