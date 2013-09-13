Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab3IMO32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:29:28 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34866 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab3IMO30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <1379049145-16017-1-git-send-email-realmz6@kernel.org>
References: <1379049145-16017-1-git-send-email-realmz6@kernel.org>
Date: Fri, 13 Sep 2013 07:29:25 -0700
X-Google-Sender-Auth: hN6-te3J6PjWcLQ2pvxP6-zdQ4o
Message-ID: <CA+55aFzJtybx3B=zcv1atCD-wUMc1YLdXndjX_d_ZxTDUpmOrQ@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Miao <realmz6@kernel.org>
Cc: adi-buildroot-devel@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:12 PM, Steven Miao <realmz6@kernel.org> wrote:
>  arch/blackfin/mach-bf609/Kconfig                   | 1655 ++++++++++++++++++++

WTF? This is getting crazy. The blackfin board Kconfig files are being
used as a DT replacement. This can't go on.

                  Linus
