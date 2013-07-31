Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616Ab3GaLcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:32:53 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:55971 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab3GaLcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:32:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130731051421.GA15766@srcf.ucam.org>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
	<3453253.oZLO1ChPbL@vostro.rjw.lan>
	<CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
	<37178266.QXgbv9rq0i@vostro.rjw.lan>
	<CAMP44s2LqiEGtS72FuTjsHUa1MH2kfaYHmcpNKMmAm2LnbFCCQ@mail.gmail.com>
	<20130731051421.GA15766@srcf.ucam.org>
Date: Wed, 31 Jul 2013 06:32:47 -0500
Message-ID: <CAMP44s2B=nQLnZm7gyYAJZgt_x3KszRZLUC=fom0t9=Eze+smA@mail.gmail.com>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lwe@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:14 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jul 30, 2013 at 07:11:06PM -0500, Felipe Contreras wrote:
>
>> No, the ACPI driver is exposing a backlight interface, which has a
>> defined stable API.
>
> From the ACPI spec:
>
> 'The OEM may define the number 0 as "Zero brightness" that can mean to
> turn off the lighting (e.g. LCD panel backlight) in the device.'
>
> There's no mechanism for an OS to know whether or not a firmware
> implementation will actually turn the backlight off at 0, so there's no
> way the OS can define the lowest backlight state as anything other than
> "May or may not turn the screen off".

Yes there is; quirks.

-- 
Felipe Contreras
