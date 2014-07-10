Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaGJRQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:16:40 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33184 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaGJRQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <CA+r1ZhhJxs_EL3UbtL8qAK4_JAqo3sJ3fF3KJ_3=NcRhnJiYjg@mail.gmail.com>
References: <CA+r1ZhhJxs_EL3UbtL8qAK4_JAqo3sJ3fF3KJ_3=NcRhnJiYjg@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 10 Jul 2014 10:15:56 -0700
Message-ID: <CAGVrzcYc+B-tsvGBspD3mujYf_mMsyRx2VoYJj3hEvwkZffX1Q@mail.gmail.com>
Subject: Re: randconfig build error with next-20140710, in net/ipv4/ipconfig.c
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org,
        Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-10 10:07 GMT-07:00 Jim Davis <jim.epost@gmail.com>:
> Building with the attached random configuration file,
>
> net/ipv4/ipconfig.c: In function ‘ic_dynamic’:
> net/ipv4/ipconfig.c:1221:3: error: ‘ic_dev_xid’ undeclared (first use
> in this function)
>    ic_dev_xid = d->xid;
>    ^
> net/ipv4/ipconfig.c:1221:3: note: each undeclared identifier is
> reported only once for each function it appears in
> make[2]: *** [net/ipv4/ipconfig.o] Error 1

Looks like David just fixed it with: http://patchwork.ozlabs.org/patch/368463/
-- 
Florian
