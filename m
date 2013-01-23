Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3AWGQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 01:16:14 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:50337 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3AWGQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 01:16:12 -0500
Message-ID: <50FF8030.4060604@gmail.xom>
Date: Wed, 23 Jan 2013 14:16:16 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Thiago Farina <tfransosi@gmail.com>,
        linux list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: listing drivers
References: <CACnwZYcXa0W3fV-fSDE1YCD2pCV350uY4QEyK+UVS4w4LDifxw@mail.gmail.com> <50FEA1BC.6070101@broadcom.com>
In-Reply-To: <50FEA1BC.6070101@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 10:27 PM, Arend van Spriel wrote:
> On 01/22/2013 02:46 PM, Thiago Farina wrote:
>> Hi folks,
>>
>> Is there a way to list the drivers installed/used in my desktop and
>> map them (the path) to their source code in the linux kernel tree?
> This might work for you (if using bash):
>
> for m in $(cat /proc/modules | gawk '{ print $1; }');do modinfo $m |
> grep 'filename:'; done
>
> Maybe any awk flavor will do.
>
> Gr. AvS
modinfo `cat /proc/modules | awk -F " " '{print $1}'`
can work.

Thanks a lot.
Zhu Yanjun
>> Thanks,
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

