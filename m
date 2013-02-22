Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3BVN0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:26:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab3BVN0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:26:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [GIT PULL] arch/arc for v3.9-rc1
Date: Fri, 22 Feb 2013 13:26:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Gilad Ben-Yossef" <gilad@benyossef.com>, Helge Deller <deller@gmx.de>,
        "Mischa Jonker" <Mischa.Jonker@synopsys.com>
References: <51271703.8050107@synopsys.com>
In-Reply-To: <51271703.8050107@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302221326.11086.arnd@arndb.de>
X-Provags-ID: V02:K0:5ZcD9RaAg9cp8Xi6AOfjMCt0s894rucoupmw+RM56/i
 wVX5Tg8AIDJtjCE4u5MqT+V2KCWhf+NsVabc18TYxxFGB//smy
 Fa7L2bDZVsrKM/PApvlsdFij26CixdtMmKkbJlKHT5cyKaG3zo
 NFzJf6wVGW5rtKqtoxLvZo8jokh56sYdcizvymySQ2mNmAgbw+
 IPutofagbFEmIPe9K6i2iowM0L8kowBhLb3RH8+OyKeePd+58l
 J7Ee78eu0cHUtKnR/b1dDy/jwWjIQ2zJ2mIsM5lzlvJTygwa/F
 nlOc9e27s8i2iWMoE7oHYkjkmTN1QST+tsnwWslPyCzQ516q8K
 kep3bAjagLaGzcRhn+NE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2013, Vineet Gupta wrote:
> I would like to introduce the Linux port to ARC Processors (from Synopsys) for
> 3.9-rc1. The patch-set has been discussed on the public lists since Nov and has
> received a fair bit of review, specially from Arnd, tglx, Al and other subsystem
> maintainers for DeviceTree, kgdb .....
> 
> The arch bits are in arch/arc, some asm-generic changes (acked by Arnd), a minor
> change to PARISC (acked by Helge).
> 
> The series is a touch bigger for a new port for 2 main reasons:
> 1. It enables a basic kernel in first sub-series and adds ptrace/kgdb/.. later
> 2. Some of the fallout of review (DeviceTree support, multi-platform-image
> support) were added on top of orig series, primarily to record the revision history.


For the series:

Acked-by: Arnd Bergmann <arnd@arndb.de>
