Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaACOBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:01:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaACOBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:01:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH, RFC 15/30] usbserial: stop using interruptible_sleep_on
Date: Fri, 3 Jan 2014 15:01:12 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-16-git-send-email-arnd@arndb.de> <20140102213629.GA12793@localhost>
In-Reply-To: <20140102213629.GA12793@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401031501.12554.arnd@arndb.de>
X-Provags-ID: V02:K0:JB9sqN0EYleZn6q5yPu4ZhT1WmxqFex0j25/ahKOeVK
 5vLanDGYHWnvZ93D5ct9x7PLBzrKypbPcTi4BMSJqYnqpZ8NnO
 WwpqwwabXvm2C4suh48nF6urQ3XmZ0EloJ7ddqzbjAayL6HWK1
 i8DGmFM17AKkhXmJeTKvtq37Mg5uFBPENb1J0CQ3uIxPjr+8yC
 fnEVkWDDsPQt8ygaA1eJ6jr09kzV1yetVFs15ayRK7QnKwgtII
 K1HhuZOuDGt3IadxYfUf11xAhGcwJQ3hGuyPpUMTvDUm/ZEVnI
 93qCGporDvSUns8zEDTix9XrrPUoiYlShhW9qquEhtbAz5P3/J
 t/0WrKG3Z8SmQlKB/eSs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 January 2014, Johan Hovold wrote:
> I'd prefer to just fix the race once and for all. These four drivers
> have been on my todo list since I converted the other usb-serial drivers
> about a year ago. In fact, I posted a fix for f81232 last week, and
> I've had a fix for pl2303 brewing as part of larger series for quite
> some time.
> 
> I'll post a conversion series to linux-usb shortly and make sure to keep
> you CC:ed on the sleep_on-killing patches.

Ah, excellent!

Much better to see the job done properly than me adding more hacks on top.

	Arnd
