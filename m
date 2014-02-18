Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaBRWPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:15:10 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58381 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751270AbaBRWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:15:08 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>, Steven Newbury <steve@snewbury.org.uk>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pci-3.14 resource alloc
Date: Tue, 18 Feb 2014 23:29:58 +0100
Message-ID: <7133100.UJBc8oSLiz@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAE9FiQXUhvG2Jub3sbBxyCERVbt-L22+O+mcZ_HWEVQ_QaRawA@mail.gmail.com>
References: <1390773698.3450.12.camel@artifact> <1392718107.15829.12.camel@artifact> <CAE9FiQXUhvG2Jub3sbBxyCERVbt-L22+O+mcZ_HWEVQ_QaRawA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 10:52:54 AM Yinghai Lu wrote:
> On Tue, Feb 18, 2014 at 2:08 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
> >> >
> >> > There's no pci bridge/bus hotplug though. Docking doesn't reveal the
> >> > pci-e->pci bridge or the (radeon) devices on the other side.
> >>
> >> oh, no. could be other regression in linus tree or pci/next.
> >>
> >
> > Previously I needed the busn work to get it working, this was included
> > in the resource-alloc branch.  It never worked on mainline, the bridge
> > used to show up but never get scanned.  Now it's not showing up at all
> > on hotplug.  It could be a dock driver regression.
> 
> I had the busn_res_alloc patches in the branch.
> 
> There is some changes about acpi dock driver from Rafael in recent
> kernels. Maybe Rafael could suggest which commit could cause problem,
> then you could try revert them on top of branch.

I kind of suspect what might have caused them, but that particular thing
would not be easy to revert.

Steven, what was the last kernel in which the bridge showed up?

Did you test 3.14-rc3?

Rafael

