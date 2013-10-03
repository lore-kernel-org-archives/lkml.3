Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JCAa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:30:28 -0400
Received: from mout.web.de ([212.227.15.4]:57075 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab3JCAaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:30:25 -0400
From: Martin Walch <walch.martin@web.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>, linux-kbuild@vger.kernel.org
Cc: Dirk Gouders <dirk@gouders.net>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <trivial@kernel.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kconfig: remove unused definition from scanner
Date: Thu, 03 Oct 2013 02:30:21 +0200
Message-ID: <1491733.iNaKkFyqph@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
In-Reply-To: <201310020857.54800.yann.morin.1998@free.fr>
References: <6249343.9Mjtul3lu5@tacticalops> <ghk3hwjhqk.fsf@lena.gouders.net> <201310020857.54800.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:X4scYzi3Q6/6ypXeoLfIQbYlmVuEKLJ8giAvNJ5mWbLlImvQIQb
 ZXZYgPReQNlpe08hr4EUht+L6IU2JeiTIvEdzT4BFB/LTgZYR3Hs6v5awEnrMskJbDpB++c
 A+X9l1L/u0xm/iPzkbUKZU5VNriC353xzH2H4nBTDYZtE90RTfs3IUJxcZ1dJdRyXD0ALTq
 D3T7uv8hzpB1Bwsc9gmjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 October 2013 08:57:54 Yann E. MORIN wrote:
> On Wednesday 02 October 2013 08:42:59 Dirk Gouders wrote:
> > I think you should also regenerate the scanner and add
> > the new zconf.lex.c_shipped to this patch.
> 
> I think sending the re-generated parser as a separate patch helps
> in reviewing. Ie. I'd prefer a fifth patch.
> 
> BTW, regenerating the parser can be done with:
>     make REGENERATE_PARSERS=1 config

Actually, I regenerated the scanner. However, the results did not change
after applying the patch, because the definition that the patch removes
(ws) is not used anywhere. It is only a cleanup.

Regenerating the scanner and the parser code with newer versions of
flex and bison results in code changes. However, they are not related to
the patch, but originate from updates in flex and bison.
Therefore I did not see any point in including the regenerated files in 
this patch set.

Of course, if you see any benefit in regenerating the *_shipped files, I can
still do so.

Regards,
Martin Walch
-- 

