Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaG3Mby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:31:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54556 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752555AbaG3Mbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:31:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: William Dauchy <wdauchy@gmail.com>
Cc: Vinson Lee <vlee@twopensource.com>, Zdenek Kabelac <zkabelac@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 2623 at drivers/pnp/pnpacpi/core.c:96 pnpacpi_set_resource
Date: Wed, 30 Jul 2014 14:50:22 +0200
Message-ID: <2051431.ekkUkyD6yC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJ75kXa_h=A9yLjG=BtY4Fk_GY+37fb+u1x1wVy2n9X8S-P9KQ@mail.gmail.com>
References: <5386F2C7.8080400@redhat.com> <8487820.GRUnuPqyXT@vostro.rjw.lan> <CAJ75kXa_h=A9yLjG=BtY4Fk_GY+37fb+u1x1wVy2n9X8S-P9KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 30, 2014 01:49:55 PM William Dauchy wrote:
> Hi Rafael,
> 
> On Wed, Jul 30, 2014 at 12:39 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > William, it would be good if you could test it too as I'd like to
> > push it for 3.16.
> 
> It also fixes the issue in 3.14.x
> 
> Tested-by: William Dauchy <william@gandi.net>

Great, thanks for testing!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
