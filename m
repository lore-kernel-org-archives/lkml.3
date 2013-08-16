Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3HPK6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:58:12 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3169 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab3HPK6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:58:11 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <520E05B5.3050507@broadcom.com>
Date: Fri, 16 Aug 2013 12:57:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Li Yang" <leoli@freescale.com>
cc: linux-pm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: System suspend states and device driver suspend() callback
References: <CADRPPNSD+uj_t5+qbNW29y7SuJkB_vMck-DGFJFV4A0AmPC6pQ@mail.gmail.com>
In-Reply-To: <CADRPPNSD+uj_t5+qbNW29y7SuJkB_vMck-DGFJFV4A0AmPC6pQ@mail.gmail.com>
X-WSS-ID: 7E10DCD12L874935134-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 10:06 AM, Li Yang wrote:
> Hi Guys,
>
> Is there a standard way for the device drivers to know if the system
> is going to “standby” mode or “mem” mode when the suspend() callbacks
> are called?

what about implementing struct device_driver::suspend?

This is for driver level suspend operation, so not per-device.

> Regards,
>
> Leo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


