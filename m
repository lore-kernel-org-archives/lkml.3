Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbaIIQVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:21:20 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:51484 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbaIIQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:21:18 -0400
MIME-Version: 1.0
X-Originating-IP: [129.2.129.155]
In-Reply-To: <1410258381-7088-4-git-send-email-yamada.m@jp.panasonic.com>
References: <1410258381-7088-1-git-send-email-yamada.m@jp.panasonic.com> <1410258381-7088-4-git-send-email-yamada.m@jp.panasonic.com>
From: Peter Foley <pefoley2@pefoley.com>
Date: Tue, 9 Sep 2014 12:20:57 -0400
Message-ID: <CAOFdcFNRp3ht-Xwc4SOh-GLyHMBxa+_6-FCvVMPvpaR_EBjnzw@mail.gmail.com>
Subject: Re: [PATCH 3/3] kbuild: remove obj-n and lib-n handling
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 6:26 AM, Masahiro Yamada
<yamada.m@jp.panasonic.com> wrote:
> Kconfig never defines CONFIG_* as 'n'.
> Now obj-n is only used in firmware/Makefile and it can be
> replaced with obj-.  No makefile uses lib-n.
>
> Let's rip off obj-n and lib-n.
>
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

Acked-by: Peter Foley <pefoley2@pefoley.com>
