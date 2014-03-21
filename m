Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbaCUJ0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:26:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26174 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760552AbaCUJZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:25:57 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-de-532c05a37884
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com
Subject: Re: [PATCH v2 0/3] ata: ahci_platform related cleanups
Date: Fri, 21 Mar 2014 10:25:34 +0100
Message-id: <3053465.Mc0SLxBG1L@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <532B3F3F.1050508@redhat.com>
References: <1395340026-3969-1-git-send-email-b.zolnierkie@samsung.com>
 <532B3F3F.1050508@redhat.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xoO5iVp1gg/eN1hbnbjWwWrw5Pp3J
	4s4KZotNj6+xWhzb8YjJ4vKuOWwW+3s3MFk0dPewW8yZsZnV4tfyo4wWKy/+ZXbg9rj+6j+T
	x85Zd9k9Nq3qZPOYM62JxePkhZMsHpuX1Hu833eVzePpj73MHsdvbGfy+LxJLoArissmJTUn
	syy1SN8ugStj4u/HLAXfuSq+vD7I0sC4n6OLkZNDQsBEYuLJQ8wQtpjEhXvr2boYuTiEBKYz
	Srxc3MAE4bQwScx8NYMVpIpNwEpiYvsqRhBbREBdYmpHD1gHs8AzJolN87aAjRIWsJdoezQd
	rIFFQFXi+/kNTCA2r4CmxLMp29hAbFEBT4kd21cC2RwcnAJaElMXlIOEhQTSJVa/m8gKUS4o
	8WPyPRYQm1lAXmLf/qmsELaOxP7WaWwTGAVmISmbhaRsFpKyBYzMqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCo+eZ1A7GlQ0WhxgFOBiVeHgrOLWDhVgTy4orcw8xSnAwK4nwLv0FFOJN
	SaysSi3Kjy8qzUktPsQozcGiJM57oNU6EOjqxJLU7NTUgtQimCwTB6dUA2P4w10Hi7XkPT6m
	6iS7tv+5zOTtXBec/GO3pJxtelhEzYaAXX/zLXY/v/Pe7+vNO0EH9s8R26G+dfmGlfL/N3/k
	80gSs3PRmxHzmfOHOKPhSbePl0utNmkwzdd8znTbQybWz09g/rNJj6MmCrrk2bxmr9M58sXt
	GpvSv7bGW+anF8TPN7jY/1qJpTgj0VCLuag4EQDgfuJumgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, March 20, 2014 08:19:27 PM Hans de Goede wrote:
> Hi,
> 
> On 03/20/2014 07:27 PM, Bartlomiej Zolnierkiewicz wrote:
> > [ v1 was named "ata: add remaining new-style AHCI platform drivers"
> >   but we are down from 2 drivers to 1 driver so the title of the patch
> >   series no longer was valid :) ]
> > 
> > Hi,
> > 
> > This patch series:
> > - fixes ahci_platform_data->suspend() handling
> > - moves library AHCI platform code to its own file
> > - adds a new-style AHCI platform driver for DaVinci DA850 AHCI controller
> > 
> > Changes since v1:
> > - dropped no longer needed patch #4 (ST SPEAr1340 AHCI controller driver)
> > - adressed review comments for patch #3 from Sekhar Nori
> > - updated patch descriptions
> 
> I assume that the spear patch has been dropped since the spear code has
> already been converted now and thus is no longer using ahci_platform_data ?

Yes, the SPEAr platform AHCI code has been replaced by a proper PHY driver.

> In that case I think it would best to replace patch 1 with a patch just dropping
> the suspend and resume callbacks from ahci_platform_data, as they then no
> longer have any users.

I have this on my TODO but since the SPEAr changes are not yet merged upstream
this have to wait a bit.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

