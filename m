Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3E1VTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:19:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63904 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235Ab3E1VTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:19:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [RFC] Add co-maintainer for fbdev
Date: Tue, 28 May 2013 23:19:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20130524153835.GF15839@game.jcrosoft.org> <201305242056.42482.arnd@arndb.de> <51A29DB9.7030505@gmx.de>
In-Reply-To: <51A29DB9.7030505@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305282319.30311.arnd@arndb.de>
X-Provags-ID: V02:K0:Yr+maXQPKWWj3956cjY5/wIO4ONvL4NYkPoDYQU+AGF
 o+6nQfDBH25RHtift3EuunRoo3DPBYA4eFfQVIArTG2CWaybd8
 mIEqkhmEvmhyvZ8TXa/BQQMLPPQb2DgR0USnYYJXDWyeL/eWm1
 8q6N7Bt0EtxrUetFG89nIBtBFd9O5KTVE1b1T1WfZN1EdXx0Ko
 mstGLWg8s8hpqdhB0Q/C+fZPQD9LF12p2Mup/BYAc8YCZZ4SKr
 5L3gXIBfPaFp7Mb3w8aXNWS682xRcBAf9hUTq1hQ7anhCVz5nN
 BZs7VgtXt4lkAx2tfbIc8GoJypEBmUovEzC2pIv+l2X2lATC27
 LpjGBFZkRE3wrF0lu8Gg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013, Florian Tobias Schandinat wrote:
> >> On Fri, May 24, 2013 at 8:38 AM, Jean-Christophe PLAGNIOL-VILLARD
> >> <plagnioj@jcrosoft.com> wrote:
> >>> Hi Florian,
> >>>
> >>>         As you seems very busy I'd like to propose the help you to handle the
> >>>         fbdev subsystem to easier the rich of the fbdev patch to Linus
> >>>
> >>>         As I'm working on fbdev on at91 and others and already Co-Maintain the
> >>>         at91 mach on ARM
> >>>
> >>>         And if you are not willing to continue I could take over
> 
> Yeah, it would be great if you could help, at the moment I get barely
> any sleep, let alone that I could keep up with the majority of mail I
> get. I'll let you decide whether you want to be sole maintainer or not.

For any bigger subsystems, it's good practice to have two maintainers,
even if one of them does all the work. I think it makes sense to have
Jean-Christophe as the primary maintainer and owner of the git tree,
but it may also be good to have you or Tomi listed as a second maintainer
for times when Jean-Christophe isn't available.

I don't know how many patches you'd expect per release, maybe just one
person is enough after all.

	Arnd
