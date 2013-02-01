Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab3BAWX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:23:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41069 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab3BAWXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:23:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [RESEND PATCH 1/4] ACPI/PM: Fix acpi_bus_get_device() check in drivers/acpi/device_pm.c
Date: Fri, 01 Feb 2013 23:30:06 +0100
Message-ID: <1912623.rgykqCuLn4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <510B018D.4050800@jp.fujitsu.com>
References: <1451967.YMyGeCCNtu@vostro.rjw.lan> <3199804.hxRfeorGhh@vostro.rjw.lan> <510B018D.4050800@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 01, 2013 08:43:09 AM Yasuaki Ishimatsu wrote:
> Hi Rafael,
> 
> 2013/02/01 5:21, Rafael J. Wysocki wrote:
> > On Thursday, January 31, 2013 12:22:14 PM Yasuaki Ishimatsu wrote:
> >> I fogot to change subject. So I resend a patch.
> >
> > I have applied patches [1-3/4] to my bleeding-edge branch,
> 
> Thanks.
> 
> > but please note that
> > something (probably your MUA) added a space in front of every line originally
> > starting with a space.
> 
> I apologize for bothering you.

No problem.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
