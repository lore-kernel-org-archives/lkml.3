Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaIIQWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:22:21 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:55459 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaIIQWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:22:16 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.155]
In-Reply-To: <1410258381-7088-2-git-send-email-yamada.m@jp.panasonic.com>
References: <1410258381-7088-1-git-send-email-yamada.m@jp.panasonic.com> <1410258381-7088-2-git-send-email-yamada.m@jp.panasonic.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 9 Sep 2014 12:21:56 -0400
Message-ID: <CAOFdcFMs7j3CAnu4XSFCSaYwKub5KcTqyz97C=0U9KbcRZEGOg@mail.gmail.com>
Subject: Re: [PATCH 1/3] kbuild: remove unnecessary "obj- := dummy.o" trick
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Wolfram Sang <wsa@sang-engineering.com>,
        Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Ulrich Hecht <ulrich.hecht@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 6:26 AM, Masahiro Yamada
<yamada.m@jp.panasonic.com> wrote:
> In these Makefiles, at least one of "obj-y" and "obj-" is non-empty,
> hence built-in.o is always created without such a trick.
>
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Acked-by: Peter Foley <pefoley2@pefoley.com>
