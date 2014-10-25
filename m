Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaJYS0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:26:35 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:41276 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaJYS0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:26:33 -0400
Message-ID: <544BDD2E.6010604@gmail.com>
Date: Sat, 25 Oct 2014 10:26:06 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>, Guenter Roeck <linux@roeck-us.net>
CC: netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
References: <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com> <54488CE1.2000106@roeck-us.net> <20141023134706.GB25190@lunn.ch> <20141023162754.GA21343@roeck-us.net> <20141023165459.GE25190@lunn.ch> <20141023173847.GA22988@roeck-us.net> <20141023180357.GG25190@lunn.ch> <20141023184322.GA24281@roeck-us.net> <20141023195526.GH25190@lunn.ch> <20141024161919.GA29600@roeck-us.net> <20141025140116.GA12051@lunn.ch>
In-Reply-To: <20141025140116.GA12051@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/14 07:01, Andrew Lunn wrote:
>> Here is another naming option:
>>
>> em1dsa0-virtual-0
> 
> I prefer this over isa.
> 
> However, i think there should be some sort of separator between the
> network device name and dsa.

Considering that network devices can be renamed, do we want it to be
included in the sensor name at all?
--
Florian
