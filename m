Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879Ab3B1WNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:13:33 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55849 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab3B1WNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:13:31 -0500
Message-ID: <512FD687.7060904@pobox.com>
Date: Thu, 28 Feb 2013 17:13:27 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-usb@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/2] ACPI / glue: Drop .find_bridge() callback from struct
 acpi_bus_type
References: <2612891.I2roH54cPk@vostro.rjw.lan> <20130228023313.GC4042@kroah.com> <1504144.f1SBuDyFqp@vostro.rjw.lan> <1995794.TENtrAZA5Q@vostro.rjw.lan>
In-Reply-To: <1995794.TENtrAZA5Q@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 04:53 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> After PCI and USB have stopped using the .find_bridge() callback in
> struct acpi_bus_type, the only remaining user of it is SATA, but SATA
> only pretends to be a user, because it points that callback to a stub
> always returning -ENODEV.
>
> For this reason, drop the SATA's dummy .find_bridge() callback and
> remove .find_bridge(), which is not used any more, from struct
> acpi_bus_type entirely.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>   drivers/acpi/glue.c       |   26 +-------------------------
>   drivers/ata/libata-acpi.c |    6 ------
>   include/acpi/acpi_bus.h   |    3 ---
>   3 files changed, 1 insertion(+), 34 deletions(-)

patches 1-2 Acked-by: Jeff Garzik <jgarzik@pobox.com>



