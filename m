Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3CDVO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:14:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab3CDVO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:14:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 0/3] arm-soc: late changes for 3.9
Date: Mon, 4 Mar 2013 21:14:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ARM SoC <arm@kernel.org>
References: <1362092093-4839-1-git-send-email-olof@lixom.net> <CA+55aFx2Cuuq2YW6mexxZ88TNm=FLYUYPzeLqN=y46oYxZJ3wQ@mail.gmail.com>
In-Reply-To: <CA+55aFx2Cuuq2YW6mexxZ88TNm=FLYUYPzeLqN=y46oYxZJ3wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303042114.49096.arnd@arndb.de>
X-Provags-ID: V02:K0:b3L1D6UCZsBTKzGuKlzl/v0fQfinoqPcZAuFKE7dvrG
 PRNnbmxSq704WcBnTPO6GjSYdPvc8eTTh4dOJWJeXMr08rLXpL
 A2EqBC81Y5y96ne/EI1uNhrNhXLYYi4PdFlxzPGOHA3Z19Q438
 5Xo3cFeMPaGZQG5RmwOA/XK4JwYB0LqcZd8US1n3zCmZVIFdr1
 bhAL7N6V4K/AQDirRukHdEFKm/b6D1Hn0v0gbJR6hH+0ebOdzj
 qxzeDMEUHqkDZLnyLG/bSa+pzXSASbaQ9UMHUPsdTjPHhZu//E
 +YrPcrB0Dokl7g7RyxUcdn31x92/6G5GuJln4kjPkGXntKMQTg
 lqKAxa8BPSKDwRGuyNL0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 March 2013, Linus Torvalds wrote:
> On Thu, Feb 28, 2013 at 2:54 PM, Olof Johansson <olof@lixom.net> wrote:
> >
> > Final two pull requests are for the same code. As Arnd describes in the
> > tags, they are for a set of mvebu patches that depend on contents in
> > the MMC tree. We had pulled in part of the MMC branch as a dependency,
> > but unfortunately Chris Ball rebased it.
> 
> Has Chris Ball been told what an incredible pain this kind of crap is,
> and that there's a damn good reason why WE DO NOT REBASE PUBLIC TREES
> THAT OTHERS MAY BE BASING THEIR DEVELOPMENT ON!
> 
> Chris, can you hear me shouting? Don't do that.

I talked to Chris while I prepared the two branches, and he now understands
the consequences and won't do it again.

I also talked to Jason Cooper about it and he is going to do his branches
differently now to avoid building deep dependency chains on other trees.
We've had similar problems with other subsystem maintainers before, but
there are a lot more subsystems that one can depend on. We generally
try to do the branches in a way that we can drop a small part of the stuff
in arm-soc without rebasing when someone else screws up, but that did not
happen in this case.

	Arnd
