Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaDRNp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:45:58 -0400
Received: from mout.gmx.net ([212.227.17.20]:52379 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaDRNp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:45:56 -0400
Message-ID: <53512C87.9040308@gmx.de>
Date: Fri, 18 Apr 2014 15:45:43 +0200
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: eparis@redhat.com, Jan Kara <jack@suse.cz>, mtk.manpages@gmail.com,
        tvrtko.ursulin@onelan.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Avoid having to provide a fake/invalid fd and path:
 update manpage
References: <1395847805-6714-1-git-send-email-xypron.glpk@gmx.de> <20140417133746.080346a8b40708a621997af2@linux-foundation.org>
In-Reply-To: <20140417133746.080346a8b40708a621997af2@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:MENfzRmxJnKaqoQHgVL6MuiMZKQ4aiQgc+09PWWzIJWFNLpfM6S
 S9My97z0P8KhK4vvlSkJpwL/siKKQ3VRHWLbDater6ry/9n+kE2kaghdrd6Qz4eqndxNsIJ
 o70iwXIh8492Pnwj3TSC8q8E6cxlNJ+GorAJRo56t+YAh6SC2uHIqCmI8LkN3gPQKaeJvx9
 H62DQvxrotaORymunwUxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The fanotify_mark() manpage should be updated to mention this.  Is that
> a thing you can take care of?
>
Currently no fanotify_mark() manpage exists. I am working with Michael 
Kerrisk on creating one.

I will mention in the BUGS section that up to Linux 3.15 a fake path is 
needed.
