Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3H2Qlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:41:45 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39473 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3H2Qlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:41:44 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20130829163744.GC19636@tucsk.piliscsaba.szeredi.hu>
References: <20130812163935.10366.88320.stgit@maximpc.sw.ru>
	<20130816112854.5630.1907.stgit@maximpc.sw.ru>
	<20130829154110.GB19636@tucsk.piliscsaba.szeredi.hu>
	<521F7672.7050407@parallels.com>
	<20130829163744.GC19636@tucsk.piliscsaba.szeredi.hu>
Date: Thu, 29 Aug 2013 18:41:42 +0200
Message-ID: <CAJfpegszfc9_ZkGGHg84VvOdmWz1=zWCnHRDbVOWf6_c-oJAXA@mail.gmail.com>
Subject: Re: [PATCH 2/2] fuse: wait for writeback in fuse_file_fallocate() -v2
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Brian Foster <bfoster@redhat.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, isn't it enough to do the filemap_write_and_wait() *plus* the
fuse_set_nowrite()?

Thanks,
Miklos
