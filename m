Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaF1IzP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 04:55:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:51215 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237AbaF1IzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 04:55:12 -0400
Message-ID: <53AE836E.7010303@kernel.org>
Date: Sat, 28 Jun 2014 09:57:18 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hartmut Knaack <knaack.h@gmx.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org, armadeus-forum@lists.sourceforge.net,
        lars@metafoo.de, devicetree@vger.kernel.org, pmeerw@pmeerw.net
Subject: Re: [PATCH v7] iio: add support of the max1027
References: <1402784830-5853-1-git-send-email-tremyfr@yahoo.fr> <53A7EE7F.1060803@gmx.de>
In-Reply-To: <53A7EE7F.1060803@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/06/14 10:08, Hartmut Knaack wrote:
> Philippe Reynes schrieb:
>> This driver add partial support of the
>> maxim 1027/1029/1031. Differential mode is not
>> supported.
>>
>> It was tested on armadeus apf27 board.
>>
>> Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
> Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
>> ---
> Not sure if it's too late, already. Looks pretty good to me, no show-stoppers. Though 3 minor issues inline, comments welcome.
As I hadn't gotten around to pushing this out to the
actual togreg branch I've added the reviewed-by.

Thanks Hartmut.

J

