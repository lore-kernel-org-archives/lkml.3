Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaJ0PiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:38:25 -0400
Received: from gloria.sntech.de ([95.129.55.99]:51258 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaJ0PiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:38:23 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jan Kardell <jan.kardell@telliq.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: rtc: NXP pcf8563 vs Haoyu hym8563
Date: Mon, 27 Oct 2014 16:41:34 +0100
Message-ID: <2860269.ao8SIdITjk@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <544E59C3.7010309@telliq.com>
References: <544E59C3.7010309@telliq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Am Montag, 27. Oktober 2014, 15:42:11 schrieb Jan Kardell:
> Hi,
> 
> Erlier this year the hym8563 driver was added to the kernel. When I compared
> the datasheets of the NXP pcf8563 (that I use) and the Haoyu hym8563 I
> cannot
> find any significantdifferences between the two chips. Now is using
> different
> drivers for the two similar (or identical?) chips:
> a) A mistake
> b) A feature
> c) Me beeing stupid?

option A - a mistake

At the time I didn't check existing drivers for one with a compatible 
interface - wrongly thinking different vendors wouldn't use the same 
interfaces.

I learned from this and am not making this mistake again [0] :-), but haven't 
had the time so far to consolidate the two rtc drivers back into one.


> The difference between the drivers is handling of century and that the
> hym8563
> driver support the clock output that both chips have.

Feel free to consolidate them if you have time to spare - alternativly I 
hopefully also will have time for this some time in the future.


Heiko


[0] https://lkml.org/lkml/2014/9/14/178
