Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaELSri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:47:38 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:59455 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbaELSrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:47:36 -0400
X-Authority-Analysis: v=2.1 cv=NN7spSKg c=1 sm=1 tr=0
 a=P1/czelPj/zYsqkqtI4LGg==:117 a=P1/czelPj/zYsqkqtI4LGg==:17 a=PuvxfXWCAAAA:8
 a=C_IRinGWAAAA:8 a=GGcpBh7Jt_oA:10 a=PMsvtofBl6QA:10 a=WuCusnQs47UA:10
 a=wPDyFdB5xvgA:10 a=NufY4J3AAAAA:8 a=nlC_4_pT8q9DhB4Ho9EA:9 a=cz2ZRIgtxKwA:10
 a=wJWlkF7cXJYA:10 a=6ohNodAXAAAA:8 a=Z4Rwk6OoAAAA:8 a=37rDS-QxAAAA:8
 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=3DdwNItBnJG09VGnV_0A:9
 a=o3X3QV6JOaEA:10 a=gDjHQkheYgsA:10 a=jbrJJM5MRmoA:10 a=6uQODOVjHeUA:10
 a=MSl-tDqOz04A:10 a=re9sYKne76oA:10 a=UTB_XpHje0EA:10 a=LI9Vle30uBYA:10
Date: Mon, 12 May 2014 13:47:32 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Jim Davis <jim.epost@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, penberg@kernel.org,
        mpm@selenic.com, linux-mm@kvack.org
Subject: Re: randconfig build error with next-20140512, in mm/slub.c
In-Reply-To: <CA+r1Zhg4JzViQt=J0XBu4dRwFUZGwi52QLefkzwcwn4NUfk8Sw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1405121346370.30318@gentwo.org>
References: <CA+r1Zhg4JzViQt=J0XBu4dRwFUZGwi52QLefkzwcwn4NUfk8Sw@mail.gmail.com>
Content-Type: MULTIPART/MIXED; BOUNDARY=e89a8f2354fd63895304f937d53f
Content-ID: <alpine.DEB.2.10.1405121346371.30318@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--e89a8f2354fd63895304f937d53f
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.10.1405121346372.30318@gentwo.org>

A patch was posted today for this issue.

Date: Mon, 12 May 2014 09:36:30 -0300
From: Fabio Estevam <fabio.estevam@freescale.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, festevam@gmail.com, Fabio Estevam
<fabio.estevam@freescale.com>,    Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH] mm: slub: Place count_partial() outside CONFIG_SLUB_DEBUG if block


On Mon, 12 May 2014, Jim Davis wrote:

> Building with the attached random configuration file,
>
> mm/slub.c: In function ¡show_slab_objects¢:
> mm/slub.c:4361:5: error: implicit declaration of function ¡count_partial¢ [-Werr
> or=implicit-function-declaration]
>      x = count_partial(n, count_total);
>      ^
> cc1: some warnings being treated as errors
> make[1]: *** [mm/slub.o] Error 1
>
--e89a8f2354fd63895304f937d53f--
