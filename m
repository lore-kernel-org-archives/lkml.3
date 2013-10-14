Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3JNLrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:47:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51155 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3JNLrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:47:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] acpi: update win8 OSI blacklist
Date: Mon, 14 Oct 2013 13:58:55 +0200
Message-ID: <1905683.dBVjOILnXT@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAMP44s0sGCDKj86awEqUK27LB=TL62-w9F=e99J3gRGmmfGMWg@mail.gmail.com>
References: <1380820383-23336-1-git-send-email-felipe.contreras@gmail.com> <CAMP44s0sGCDKj86awEqUK27LB=TL62-w9F=e99J3gRGmmfGMWg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 13, 2013 10:30:50 PM Felipe Contreras wrote:
> On Thu, Oct 3, 2013 at 12:13 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
> > More people have reported they need this for their machines to work
> > correctly.
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=60682
> 
> I see this was merged to the linux-next branch. Is there any reason
> why it's not proposed for v3.12?

It is not a fix for a recent breakage, it doesn't fix an outright crash or
security issue and there is a chance, albeit arguably very small, that
something will not function on one of the affected systems for someone
as a result of the blacklisting.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
