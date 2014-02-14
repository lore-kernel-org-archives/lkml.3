Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaBNTLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:11:37 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50516 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaBNTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:11:36 -0500
MIME-Version: 1.0
In-Reply-To: <1392392764.3520.11.camel@devel-n900>
References: <1390773698.3450.12.camel@artifact>
	<CAE9FiQVD=oVHM5WJgSJ5cNpXZ1NYy9E_pcGWfjKnmD9OZoHHsw@mail.gmail.com>
	<1391643656.1067.1.camel@artifact>
	<CAE9FiQV8jutRhaBicL4kjqVYd07FzHmNoSN3NxdA2TYvOc_KUg@mail.gmail.com>
	<z9zi9m.n0zpxd.1hgeaud-qmf@mail.snewbury.org.uk>
	<i9nn22.n0zs79.1hgeaud-qmf@mail.snewbury.org.uk>
	<1392392764.3520.11.camel@devel-n900>
Date: Fri, 14 Feb 2014 11:11:35 -0800
X-Google-Sender-Auth: cVJZGWdhlF0n1sr-TGKty13VVxY
Message-ID: <CAE9FiQV3H_nxH0gxcM0kW4uLm6b_qmHT9hRQUVY_4xPqjpvMtA@mail.gmail.com>
Subject: Re: pci-3.14 resource alloc
From: Yinghai Lu <yinghai@kernel.org>
To: Steven Newbury <steve@snewbury.org.uk>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 7:46 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
>>
>> Oh, never mind! I didn't notice pref_bar has been renamed to
>> assign_pref_bars. It's working now! :)
>
> There's no pci bridge/bus hotplug though. Docking doesn't reveal the
> pci-e->pci bridge or the (radeon) devices on the other side.

oh, no. could be other regression in linus tree or pci/next.

Can you check if linus tree could reveal pci-e->pci bridge?

or do you use iommu/dmar with the system?

Thanks

Yinghai
