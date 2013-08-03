Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3HCX1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 19:27:52 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:34966 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3HCX1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 19:27:49 -0400
Message-ID: <1375572464.1988.4.camel@ThinkPad-X230.localdomain>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.11-rc4
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Sun, 04 Aug 2013 03:27:44 +0400
In-Reply-To: <CAMP44s2HSEnhWfgtvSmu3K-nrWzHnxfj44hpvAVerRQq-dUABg@mail.gmail.com>
References: <2052880.bHfzt6NKt5@vostro.rjw.lan>
	 <6100577.WGRZRabKGy@vostro.rjw.lan>
	 <CAMP44s1Knox3oVt3-ePkDHxa2uNQAFVFRwmVTATNknWA46b_Uw@mail.gmail.com>
	 <1963015.Y2AObmEn2f@vostro.rjw.lan>
	 <1375546086.1988.2.camel@ThinkPad-X230.localdomain>
	 <CAMP44s2HSEnhWfgtvSmu3K-nrWzHnxfj44hpvAVerRQq-dUABg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-03 at 15:21 -0500, Felipe Contreras wrote:
> On Sat, Aug 3, 2013 at 11:08 AM, Igor Gnatenko
> <i.gnatenko.brain@gmail.com> wrote:
> 
> > I am opposed to this patch. On ThinkPad X230 I had problems with it.
> > Felipe, come over to dark side. They have cookies.
> 
> And v3.11-rc3 works's fine out-of-the box?
> 

rc2 work's fine. Since rc3 Rafael reverted patch and I think backlight
broken again (I don't have time to check rc3 yet).
-- 
Igor Gnatenko
Fedora release 19 (Schrödinger’s Cat)
Linux 3.10.4-300.fc19.x86_64

