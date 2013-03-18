Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3CRICl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:02:41 -0400
Received: from mx02.infracom.it ([62.196.48.10]:26345 "EHLO mx02.infracom.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3CRICi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:02:38 -0400
Message-ID: <5146CA1A.3000705@infracom.it>
Date: Mon, 18 Mar 2013 09:02:34 +0100
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot
 on HP 6730B - bisected
References: <513D8F3A.8030308@gmail.com> <12541380.EkF6PjBYxc@vostro.rjw.lan> <51457F9F.7000204@infracom.it> <2925166.8AVI1SWGSM@vostro.rjw.lan>
In-Reply-To: <2925166.8AVI1SWGSM@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/03/2013 00:27, Rafael J. Wysocki ha scritto:
>
> Please try to boot with initcall_debug in the kernel command line and see
> if that works around the problem and if not, whether or not it provides a
> clue about the point where boot is stuck (and if that point is always the
> same).

initcall_debug makes no difference.
Going back to console=ttyS0 it seems that enabling serial console
gives a 100% boot success ratio. Unfortunately this means that I
can't capture the error with a serial console. This evening I'll
try with a 60 fps camera to see if I can get more info.

Regarding the point of failure I see that sometimes the boot is
stuck with an empty screen, sometimes it outputs the attended
stack trace (always booting with the same kernel command line
obviously).

Kind regards
R



