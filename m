Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbaIIQ25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:28:57 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:55966 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbaIIQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:28:55 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.155]
In-Reply-To: <1410260544-22657-2-git-send-email-yamada.m@jp.panasonic.com>
References: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com> <1410260544-22657-2-git-send-email-yamada.m@jp.panasonic.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 9 Sep 2014 12:28:35 -0400
Message-ID: <CAOFdcFM78JKo9Q+VwviBuFjfPWim63cqu2jgDhLT=KhWx4We4A@mail.gmail.com>
Subject: Re: [PATCH 1/3] kbuild: fake the "Entering directory ..." message
 more simply
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 7:02 AM, Masahiro Yamada
<yamada.m@jp.panasonic.com> wrote:
> Commit c2e28dc975ea87feed84415006ae143424912ac7
> (kbuild: Print the name of the build directory)
> added a gimmick to show the "Entering directory ...".
>
> Instead of echoing the hard-coded message (that is, we need to know
> the exact message), moving --no-print-directory would be easier.
>
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Acked-by: Peter Foley <pefoley2@pefoley.com>
