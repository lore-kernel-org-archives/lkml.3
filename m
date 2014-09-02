Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaIBMPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 08:15:41 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52126 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaIBMPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:15:40 -0400
Message-ID: <5405B4E6.1040908@gmail.com>
Date: Tue, 02 Sep 2014 20:15:34 +0800
From: Chunwei Chen <tuxoko@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [uas/3.16.1] panic in uas_data_cmplt()
References: <54054509.2070609@gmail.com> <540568A3.4010106@redhat.com>
In-Reply-To: <540568A3.4010106@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 西元2014年09月02日 14:50, Hans de Goede wrote:
> Hi,
> 
> On 09/02/2014 06:18 AM, Chunwei Chen wrote:
>> Dear all:
>>
>> The kernel version is 3.16.1-1-ARCH
>>
>> Today I keep getting this panic when booting up.
>> http://i.imgur.com/0Rx93Kr.jpg
>>
>> It might be that the UAS device was in some strange state,
>> because that after I unplugged and power-cycled the UAS,
>> everything went normal again.
>>
>> Does anyone know what's the root cause of this issue?
>> Or could anyone provide some instruction on how to debug this issue?
> 
> There seem to be some issues in the error handling paths of the uas
> driver. I plan to rewrite them completely for robustness and go
> through them with a fine comb to fix any possible bugs while at it.
> 
> I'll send out a mail when I've a new version ready for testing.
> 
> Regards,
> 
> Hans
> 

Hi Hans,

Thanks for looking into this.

Kind regards,
Chunwei
