Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3DXQtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:49:17 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:55517 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3DXQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:49:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAG82n_ni9ZAThGbMfqqObnz7QyQpH18G4hYBLt+BdeRHPE6EBg@mail.gmail.com>
References: <CAG82n_ni9ZAThGbMfqqObnz7QyQpH18G4hYBLt+BdeRHPE6EBg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 24 Apr 2013 10:48:54 -0600
Message-ID: <CAErSpo5VaiuH+WT4RdM9yU9AHMkUKzATMiNzhixRU04_aZusBg@mail.gmail.com>
Subject: Re: [RFC] The meaning of local_cpulist and local_cpus
To: Bian LuLu <helianthus.lu@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mike Travis <travis@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci, Mike]

On Wed, Apr 24, 2013 at 4:06 AM, Bian LuLu <helianthus.lu@gmail.com> wrote:
> Hi all,
>
> Recently, i read some codes of PCI portions. I think
> local_cpulist is a list about one kind of CPU and
> local_cpus is a mask of CPU. But i am not sure when
> and how i should use these two parameters.
>
> See http://lxr.linux.no/linux+v3.5.4/drivers/pci/pci-sysfs.c#L390 for
> details.
>
> Would anyone please give me some suggestions?
> Thanks in advance ;-)

I don't know off-hand, but maybe Mike or somebody on linux-pci does.
It looks like Mike added local_cpulist with 39106dcf85.
