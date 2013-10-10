Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3JJMra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:47:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42762 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab3JJMr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:47:29 -0400
Message-ID: <5256A1DE.8010709@ti.com>
Date: Thu, 10 Oct 2013 07:47:26 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Steve Glendinning <steve.glendinning@shawell.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, <mugunthanvnm@ti.com>
Subject: Re: [PATCH] usbnet: smsc95xx: Add device tree input for MAC address
References: <1380911156-14112-1-git-send-email-dmurphy@ti.com>	<CACVXFVOVMvP=3y9h2Jrqn2sBQdKOZtrhQDAFYkdHKXFgQj=d0Q@mail.gmail.com>	<52519E7A.40804@ti.com>	<CACVXFVNAB3VnmdoP_LGJsBjQ17j1aoqKMsBE7LRt65OqROeRUQ@mail.gmail.com>	<525698CC.3060406@ti.com> <CACVXFVP-KgqcNTnk+JZsLc188pYk6iUXvW6=kPXNaurSuevGeA@mail.gmail.com>
In-Reply-To: <CACVXFVP-KgqcNTnk+JZsLc188pYk6iUXvW6=kPXNaurSuevGeA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 07:39 AM, Ming Lei wrote:
> On Thu, Oct 10, 2013 at 8:08 PM, Dan Murphy <dmurphy@ti.com> wrote:
>> You are correct I don't expect a match for PnP devices only devices that are hard wired.
>>
>> After thinking of it I should move the OF code below the EEPROM code as the EEPROM should take preference over the DT code.
>>
>> I will need to post V2 for that.
> Your patch still doesn't deal with two smsc95xx devices built in
> one board.

Is there a board that has 2 built in smsc devices?

This is all dependent on what the dev.id is of udev.

>
> The problem is a generic one, looks it is better to do it when OF supports
> discoverable bus.
>
>
> Thanks,


-- 
------------------
Dan Murphy

