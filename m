Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab3JJMur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:50:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62135 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753526Ab3JJMuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:50:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] ACPI power management support for I2C and SPI devices
Date: Thu, 10 Oct 2013 15:02:17 +0200
Message-ID: <2209223.2krlQWGy9Q@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381400928-2689-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1381327461-10562-1-git-send-email-mika.westerberg@linux.intel.com> <1381400928-2689-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 10, 2013 01:28:45 PM Mika Westerberg wrote:
> Here is an updated version. I added acks from Mark and Wolfram and dropped
> if (ACPI_HANDLE()) checks as requested. This is already handled by
> acpi_dev_pm_attach()/detach().
> 
> Rafael,
> 
> If you are OK with these, could you merge the series to your ACPI tree?
> 
> Thanks!

I will, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
