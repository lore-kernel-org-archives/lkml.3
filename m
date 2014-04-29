Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbaD2LYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:24:43 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38790 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933876AbaD2LYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:24:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAAG0J9-2=rP3RP08eEjd17R3wEaeiUtGfWD-LeqXV=y9sBamfA@mail.gmail.com>
References: <1398247687-13453-1-git-send-email-james.hogan@imgtec.com>
	<1398247687-13453-4-git-send-email-james.hogan@imgtec.com>
	<201404231418.05174.arnd@arndb.de>
	<CAAG0J9-2=rP3RP08eEjd17R3wEaeiUtGfWD-LeqXV=y9sBamfA@mail.gmail.com>
Date: Tue, 29 Apr 2014 13:24:36 +0200
X-Google-Sender-Auth: js8GORr9Idcm3vDrPeklIJ4nkjQ
Message-ID: <CAELBmZB=74foyc_b-MTVOXeP6rVAD2x4=um2RVezTb68DifEbA@mail.gmail.com>
Subject: Re: [RFC 3/3] asm-generic: Drop renameat syscall from default list
From: Szeredi Miklos <miklos@szeredi.hu>
To: James Hogan <james.hogan@imgtec.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Miklos Szeredi <mszeredi@suse.cz>,
        linux-arch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        metag <linux-metag@vger.kernel.org>, Jonas Bonn <jonas@southpole.se>,
        linux@openrisc.net, Chen Liqin <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 2:41 PM, James Hogan <james.hogan@imgtec.com> wrote:

> It appears Miklos Szeredi beat me to it with patch 1 (adding renameat2
> syscall to asm-generic unistd.h), and will be submitting it to Linus
> at some point as part of his renameat2 series.
> Miklos: Do you think it makes sense for you to include my second patch
> in your series too since it's renameat2 related?
> http://marc.info/?l=linux-kernel&m=139824773305016&w=2

I've queued up the first two patches with acks from Arnd.

Thanks,
Miklos
