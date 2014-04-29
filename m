Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbaD2Pao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:30:44 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57613 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757458AbaD2Pan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:30:43 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: wsa@the-dreams.de, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 0/9] I2C ACPI operation region handler support
Date: Tue, 29 Apr 2014 17:47:11 +0200
Message-ID: <1527127.pmk7LiQ709@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <535F0666.1090409@intel.com>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <43726986.W0L99n76oE@vostro.rjw.lan> <535F0666.1090409@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 09:54:46 AM Lan Tianyu wrote:
> On 2014年04月29日 06:51, Rafael J. Wysocki wrote:
> > On Monday, April 28, 2014 10:27:39 PM Lan Tianyu wrote:
> >> ACPI 5.0 spec(5.5.2.4.5) defines GenericSerialBus(i2c, spi, uart) operation
> >> region. It allows ACPI aml code able to access such kind of devices to
> >> implement some ACPI standard method.
> >>
> >> On the Asus T100TA, Bios use GenericSerialBus operation region to access
> >> i2c device to get battery info. So battery function depends on the I2C
> >> operation region support. Here is the bug link.
> >> https://bugzilla.kernel.org/show_bug.cgi?id=69011
> >>
> >> This patchset is to add I2C ACPI operation region handler support.
> >>
> >> Change Since V1:
> >>        Fix some code style and memory leak issues in Patch 7
> > 
> > Is it the only patch that has changed from v1?
> 
> 
> I also remove a redundant semicolon in the PATCH 8. Sorry. I didn't
> notice these patches are already in your tree. I will produce divergence
> patches based on your bleeding-edge branch.

No need for that, I'll use the new versions.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
