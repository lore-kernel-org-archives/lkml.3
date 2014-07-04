Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaGDIk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:40:26 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.182]:53608 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaGDIkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:40:24 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGoheedClaTaNdBkW0QEOcx1Ft+DpaWf0qqN8/jSv6KcucO/Jal+pWlFmof8RwlK56M1DtI=
X-RZG-CLASS-ID: mo05
Message-ID: <53B6687A.3070108@denx.de>
Date: Fri, 04 Jul 2014 10:40:26 +0200
From: Stefan Roese <sr@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jean-Michel Hautbois <jhautbois@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Lattice ECP3 load firmware
References: <CAL8zT=jVVJ7WB7PtXwbKji5efoZHxWVwD4LgVsuXc3gsW+9=kw@mail.gmail.com>
In-Reply-To: <CAL8zT=jVVJ7WB7PtXwbKji5efoZHxWVwD4LgVsuXc3gsW+9=kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Michel,

On 04.07.2014 10:24, Jean-Michel Hautbois wrote:
> I noticed you (Stefan) are using request_firmware_nowait() call. This
> means user needs to explicitly call it using
>
> $ echo 1 > /sys/class/firmware/lattice-ecp3.0/loading
> $ cat lattice-ecp3.bit > /sys/class/firmware/lattice-ecp3.0/data
> $ echo 0 > /sys/class/firmware/lattice-ecp3.0/loading
>
> Or did I miss something ?

No, thats correct. This is how we use it on our platform.

> I would like to have it load the firmware bitstream when booting if
> there is a specific .bit file in /lib/firmware. Maybe don't you want
> to have this behaviour, though... ?

No. We don't want this. Please don't ask me about the details. Its quite 
a while ago that I worked on this platform. And I don't have access to 
this platform any more.

Thanks,
Stefan

