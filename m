Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaEGCr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 22:47:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52522 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbaEGCrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 22:47:25 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53699EB1.6040007@roeck-us.net>
Date: Tue, 06 May 2014 19:47:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tomas Pop <tomas.pop.mff@gmail.com>
CC: "jdelvare@suse.de" <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        johannes.winkelmann@sensirion.com
Subject: Re: [RFC][PATCH v2] hwmon: add support for Sensirion SHTC1 sensor
References: <1398985530.17142.15.camel@ltli10.sensirion.lokal>			 <5362FDA9.8080300@roeck-us.net>			 <1399064369.3019.83.camel@ltli10.sensirion.lokal>			 <20140502231528.GA5157@roeck-us.net>		 <1399338214.24993.10.camel@ltli10.sensirion.lokal>		 <53683D38.7010904@roeck-us.net>	 <1399341707.24993.20.camel@ltli10.sensirion.lokal>	 <536853C0.8020406@roeck-us.net> <1399392184.3691.15.camel@ltli10.sensirion.lokal>
In-Reply-To: <1399392184.3691.15.camel@ltli10.sensirion.lokal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 09:03 AM, Tomas Pop wrote:
> Hi Gunter,
>
> Yes, that's exactly the idea - we would like to provide basic support
> for a few low-cost boards as a starting point for anybody who is
> interested in the sensor. Previously I was testing mostly on some
> Android devices (kernel 3.4), and it seems, that a lot of thinks changed
> in since version 3.4 :-)
>
> I will send in few days a tested version..
>
Great. Unfortunately those chips are so small that they don't fit on
my test boards, or I would have ordered some myself. I am looking forward
to see those boards available for order somewhere ... hopefully at a lower
price point than your evaluation boards ;-).

Thanks,
Guenter

