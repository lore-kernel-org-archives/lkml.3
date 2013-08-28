Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3H1B0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:26:24 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41988 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3H1B0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:26:23 -0400
Date: Tue, 27 Aug 2013 18:21:44 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bq24190_charger: Add support for TI BQ24190 Battery
 Charger
Message-ID: <20130828012144.GC10506@lizard>
References: <1377310863-32209-1-git-send-email-mgreer@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1377310863-32209-1-git-send-email-mgreer@animalcreek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 07:21:03PM -0700, Mark A. Greer wrote:
> Add driver support for the Texas Instruments BQ24190
> battery charger.  Some of the information provided by
> the device is about the charger and other information
> is about the battery so create two power_supply objects
> (one for each) and provide the appropriate information
> for each one.
> 
> The device has many fields that go beyond what is
> reasonable to report or modify using the existing
> 'POWER_SUPPLY_PROP_*' properties so the driver exports
> the register fields via sysfs.  They are prefixed by
> 'f_' (for 'field') to make it easier to distinguish
> between a register field and a "normal" sysfs file
> exported by the power_supply infrastructure.
> 
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---

Applied, thanks a lot!

Anton
