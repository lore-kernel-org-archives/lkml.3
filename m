Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbaDVP7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:59:19 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:64384 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbaDVP7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:59:01 -0400
MIME-Version: 1.0
In-Reply-To: <10435496.M4aSBzoVye@grover>
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>
	<2619529.mEMJol0YfM@grover>
	<1549585.kmUPduLgev@grover>
	<10435496.M4aSBzoVye@grover>
Date: Tue, 22 Apr 2014 08:59:00 -0700
X-Google-Sender-Auth: IrruAix4SsdCn3mIqDA1EMUt_nc
Message-ID: <CA+55aFwbOQCcd1qsW0rA+bQxN2Vgm9x832ZKmB7fndFX7DBE3w@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ed Tomlinson <edt@aei.ca>
Cc: Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, mind sending me a pull request for drm fixes?

There's now at least these two:

 - "drm/radeon/aux: fix hpd assignment for aux bus"
 - "drm/radeon: use fixed PPL ref divider if needed"

that look like fairly fatal regressions when they affect somebody.

The fact that we already had *two* independent bugs be reported within
days of that last out-of-merge-window pull request makes me very
unhappy with the state of drm pulls.

So please make sure that future fixes really are *fixes*. For
regressions only. No more games like this.

                 Linus
