Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965932Ab3HIJg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:36:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52494 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965421Ab3HIJgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:36:25 -0400
Date: Fri, 9 Aug 2013 11:36:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        joseph.salisbury@canonical.com,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] HID: hid-logitech-dj, querying_devices was never
 set
In-Reply-To: <520164A5.2020008@molgaard.org>
Message-ID: <alpine.LNX.2.00.1308091136060.13089@pobox.suse.cz>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com> <1374153691-25100-2-git-send-email-nlopezcasad@logitech.com> <CAN+gG=GcS7pfK9K5FuW9TyX+PJWNkXZWLk8UX9PzLXom2PSpgQ@mail.gmail.com> <alpine.LNX.2.00.1308020309340.24017@pobox.suse.cz>
 <CAN+gG=FV=OjnktkET-_KM_iTPStsWCKdj8fpyktnJczusFz0=w@mail.gmail.com> <alpine.LNX.2.00.1308051516181.17512@pobox.suse.cz> <CAN+gG=Hjd1Ay0=HrJdV9797DxTMf97_13kdkuHNWi24EfPL-ig@mail.gmail.com> <520164A5.2020008@molgaard.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Aug 2013, Sune Mølgaard wrote:

> Being affected by this bug, I can confirm that Linux 3.11-rc4 still
> exhibits the unwanted behaviour for me, but that commenting out the
> single line from the second patch makes it work.
> 
> Thus, for requesting a revert on that line, you are most welcome to put
> me down as a "Tested-By".

Okay, this is now queued, and I will be pushing it to Linus.

Thanks,

-- 
Jiri Kosina
SUSE Labs
