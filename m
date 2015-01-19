Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbbASOyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:54:22 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:53134 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbbASOyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:54:18 -0500
Date: Mon, 19 Jan 2015 09:54:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/4] ata: libahci: Allow using a regulator for each
 port
Message-ID: <20150119145413.GJ8140@htj.dyndns.org>
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com>
 <54B8C49A.9070302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B8C49A.9070302@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 08:58:18AM +0100, Hans de Goede wrote:
> Hi,
> 
> On 15-01-15 15:09, Gregory CLEMENT wrote:
> >The current implementation of the libahci allows using one PHY per
> >port but we still have one single regulator for the whole
> >controller. This series adds the support of multiple regulators.
> >
> >This is the forth version of the series.
> >
> >The improvement of this version is the use of
> >ahci_platform_put_resources to put the reference to the regulators.
> >
> >Thanks,
> >
> >Grégory
> 
> Thanks, patches 1 - 3 look good and are:
> 
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> 
> Tejun, can you please queue up 1 - 3 ?

Applied 1-3 to libata/for-3.20.

Thanks.

-- 
tejun
