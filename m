Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaLQOz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:55:26 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:36634 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:55:24 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2014 09:55:24 EST
Message-ID: <54919786.7020605@auriga.com>
Date: Wed, 17 Dec 2014 17:47:34 +0300
From: Aleksey Makarov <aleksey.makarov@auriga.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Leonid Rosenboim <lrosenboim@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 09/14] MIPS: OCTEON: Add ability to used an initrd from
 a named memory block.
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com> <1418666603-15159-10-git-send-email-aleksey.makarov@auriga.com> <20141215205316.GA10323@fuloong-minipc.musicnaut.iki.fi>
In-Reply-To: <20141215205316.GA10323@fuloong-minipc.musicnaut.iki.fi>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/15/2014 11:53 PM, Aaro Koskinen wrote:
> On Mon, Dec 15, 2014 at 09:03:15PM +0300, Aleksey Makarov wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> If 'rd_name=xxx' is passed to the kernel, the named block with name
>> 'xxx' is used for the initrd.
> 
> Maybe use "initrd_name" for consistency or even just "initrd"
> (if the xxx is not in form of "address,size" you could assume it to refer
> to a named block).

As far as I can see it is already consistent as MIPS Linux uses "rd_start" and "rd_size" instead of "initrd".

Aleksey

> 
> A.
> .
> 
