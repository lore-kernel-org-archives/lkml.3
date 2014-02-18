Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaBRSw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:52:58 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56723 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaBRSwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:52:55 -0500
MIME-Version: 1.0
In-Reply-To: <1392718107.15829.12.camel@artifact>
References: <1390773698.3450.12.camel@artifact>
	<CAE9FiQVD=oVHM5WJgSJ5cNpXZ1NYy9E_pcGWfjKnmD9OZoHHsw@mail.gmail.com>
	<1391643656.1067.1.camel@artifact>
	<CAE9FiQV8jutRhaBicL4kjqVYd07FzHmNoSN3NxdA2TYvOc_KUg@mail.gmail.com>
	<z9zi9m.n0zpxd.1hgeaud-qmf@mail.snewbury.org.uk>
	<i9nn22.n0zs79.1hgeaud-qmf@mail.snewbury.org.uk>
	<1392392764.3520.11.camel@devel-n900>
	<CAE9FiQV3H_nxH0gxcM0kW4uLm6b_qmHT9hRQUVY_4xPqjpvMtA@mail.gmail.com>
	<1392718107.15829.12.camel@artifact>
Date: Tue, 18 Feb 2014 10:52:54 -0800
X-Google-Sender-Auth: VEs3YGOPU-_fnad3Qf7KZUL4VBA
Message-ID: <CAE9FiQXUhvG2Jub3sbBxyCERVbt-L22+O+mcZ_HWEVQ_QaRawA@mail.gmail.com>
Subject: Re: pci-3.14 resource alloc
From: Yinghai Lu <yinghai@kernel.org>
To: Steven Newbury <steve@snewbury.org.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 2:08 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
>> >
>> > There's no pci bridge/bus hotplug though. Docking doesn't reveal the
>> > pci-e->pci bridge or the (radeon) devices on the other side.
>>
>> oh, no. could be other regression in linus tree or pci/next.
>>
>
> Previously I needed the busn work to get it working, this was included
> in the resource-alloc branch.  It never worked on mainline, the bridge
> used to show up but never get scanned.  Now it's not showing up at all
> on hotplug.  It could be a dock driver regression.

I had the busn_res_alloc patches in the branch.

There is some changes about acpi dock driver from Rafael in recent
kernels. Maybe Rafael could suggest which commit could cause problem,
then you could try revert them on top of branch.

Thanks

Yinghai
