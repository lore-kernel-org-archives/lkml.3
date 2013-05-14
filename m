Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab3ENUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 16:25:58 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46855 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895Ab3ENUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 16:25:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: REGRESSION: 3.10-rc1: Dell Latitude e6410 hangs within 3 seconds
Date: Tue, 14 May 2013 22:34:30 +0200
Message-ID: <1396357.SFbZsj3Bmy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5192363E.7040204@broadcom.com>
References: <5192363E.7040204@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 14, 2013 03:03:58 PM Arend van Spriel wrote:
> Laptop hangs pretty soon after booting. Workaround for me was to turn 
> off ACPI on kernel command line, ie. acpi=off
> 
> Attached is my kernel configuration.

Well, I have no idea what may be the source of this.

Any chance to bisect?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
