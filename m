Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaHMBRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 21:17:50 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:38694 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaHMBRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 21:17:45 -0400
MIME-Version: 1.0
In-Reply-To: <53EA4F34.4050402@infradead.org>
References: <1407525394-29821-1-git-send-email-standby24x7@gmail.com>
	<53EA4F34.4050402@infradead.org>
Date: Tue, 12 Aug 2014 22:17:43 -0300
Message-ID: <CAOMZO5B_zXvMybFhr4mU2wvx4Boh-P3Tn5GLopUJU8A24mjdBA@mail.gmail.com>
Subject: Re: [PATCH] Documentation: DocBook: Rename drm_stub.c to drm_drv.c
 cause 'make xmldocs' failed
From: Fabio Estevam <festevam@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Masanari Iida <standby24x7@gmail.com>, Jim Davis <jim.epost@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 2:30 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> This patch fixed 'make xmldocs' failed on linus's tree and
> linux-next as of 8th/Aug,2014.
>
> When drm merge for 3.17-rc1 happen,  a file was renamed from
> drm_stub.c to drm_drv.c.
> But Documentation/DocBook/drm.tmpl still have an old file name.
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Isn't the From field missing to indicate Masanari's authorship of this patch?
