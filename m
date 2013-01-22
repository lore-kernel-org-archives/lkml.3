Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab3AVO1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:27:21 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4147 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3AVO1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:27:20 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <50FEA1BC.6070101@broadcom.com>
Date: Tue, 22 Jan 2013 15:27:08 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Thiago Farina" <tfransosi@gmail.com>
cc: "linux list" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: listing drivers
References: <CACnwZYcXa0W3fV-fSDE1YCD2pCV350uY4QEyK+UVS4w4LDifxw@mail.gmail.com>
In-Reply-To: <CACnwZYcXa0W3fV-fSDE1YCD2pCV350uY4QEyK+UVS4w4LDifxw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-WSS-ID: 7CE07FF53Q44927817-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 02:46 PM, Thiago Farina wrote:
> Hi folks,
> 
> Is there a way to list the drivers installed/used in my desktop and
> map them (the path) to their source code in the linux kernel tree?

This might work for you (if using bash):

for m in $(cat /proc/modules | gawk '{ print $1; }');do modinfo $m |
grep 'filename:'; done

Maybe any awk flavor will do.

Gr. AvS

> Thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


