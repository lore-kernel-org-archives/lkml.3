Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaABUBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:01:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaABUBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:01:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] at91: dt: sam9261: Added DM9000 in the device tree
Date: Thu, 02 Jan 2014 21:00:57 +0100
Message-ID: <1460399.vQDGWoVpz2@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CACh+v5PptkrXERAqBUOv-DSaRDQ5NzJAc919Ne3iN9iVszRP+A@mail.gmail.com>
References: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com> <4526077.qASk8HSHKP@wuerfel> <CACh+v5PptkrXERAqBUOv-DSaRDQ5NzJAc919Ne3iN9iVszRP+A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tqxZDcaEwFxciQTDxIFBmxw0DvkD+aJVBmU4Hry05lr
 osjfaquptmqY4Q22ahM1tegLlBqm9n9XAcVWe2PxWmhmim9UB7
 XdHaGR7FfhpMmMh+n/iwIbSWt22aFSMFZHs2zgH9NU+hAkxX1Y
 xhr1NX1CbaMGJAzfAD4WVTTcWFKsq3Ub+s0TzkDlqwrJVPaHX7
 rW81qfX5l/Y+w02SObQLmn8hLAipiAMhjZNEmEdvM8A3Q6IFNV
 lmd1reI53p1G5D22F9ZAj1qFQMWSm8njF6BmbjSWc+g2kf+pYP
 8xCMryTG+JW4WCcq1m8yPVxmDtOLcBe+UxcURdOlulHa3Fp3wt
 IfqzPXcIAixt21gsLP9g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 January 2014 20:31:00 Jean-Jacques Hiblot wrote:
> > If each bus interface has a fixed range of registers, you can actually
> > collapse the upper two nodes again and just have one device per
> > chipselect.
> This is indeed the case, but I'd rather keep the top node to highlight
> the fact that all the devices are physically tied to the same bus.

How about using a top-level "simple-bus" node with the complex ranges
property but making the driver match the sub-devices with the smaller
register range then?

	Arnd
