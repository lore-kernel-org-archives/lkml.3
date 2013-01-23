Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3AWRYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:24:19 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3716 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab3AWRYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:24:18 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51001CB6.2090900@broadcom.com>
Date: Wed, 23 Jan 2013 18:24:06 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Thiago Farina" <tfransosi@gmail.com>
cc: "linux list" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: listing drivers
References: <CACnwZYcXa0W3fV-fSDE1YCD2pCV350uY4QEyK+UVS4w4LDifxw@mail.gmail.com>
 <50FEA1BC.6070101@broadcom.com>
 <CACnwZYeS2=LJuuHJhpTtdijj+xXYiYZ2_hZNShGo9q8_J-pkMQ@mail.gmail.com>
In-Reply-To: <CACnwZYeS2=LJuuHJhpTtdijj+xXYiYZ2_hZNShGo9q8_J-pkMQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-WSS-ID: 7D1EC4F23Q45360186-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 04:30 PM, Thiago Farina wrote:
> Hi,
> 
> On Tue, Jan 22, 2013 at 12:27 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 01/22/2013 02:46 PM, Thiago Farina wrote:
>>> Hi folks,
>>>
>>> Is there a way to list the drivers installed/used in my desktop and
>>> map them (the path) to their source code in the linux kernel tree?
>>
>> This might work for you (if using bash):
>>
>> for m in $(cat /proc/modules | gawk '{ print $1; }');do modinfo $m |
>> grep 'filename:'; done
>>
> Thanks a lot Arend! That is exactly what I wanted ;)

You are welcome. Of course, not all modules are (device) drivers.

Gr. AvS

> --
> Thiago
> 


