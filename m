Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaHDBXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 21:23:36 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43396 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbaHDBXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 21:23:35 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s741N2iv024343, This message is accepted by code: ctloc85258
Message-ID: <53DEE078.2060506@realsil.com.cn>
Date: Mon, 4 Aug 2014 09:23:04 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Fabio Falzoi <fabio.falzoi84@gmail.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, <joe@perches.com>,
        <dan.carpenter@oracle.com>, <wei_wang@realsil.com.cn>
Subject: Re: [PATCH v5 3/4] Staging: rts5208: Use dev_dbg and %*phspecifiertodump memory
References: <1406672155-13187-1-git-send-email-fabio.falzoi84@gmail.com> <1406672155-13187-4-git-send-email-fabio.falzoi84@gmail.com> <53D84FE3.9040709@realsil.com.cn> <20140801175526.GA19125@PippoloLaptop>
In-Reply-To: <20140801175526.GA19125@PippoloLaptop>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2014 01:55 AM, Fabio Falzoi wrote:
> On Wed, Jul 30, 2014 at 09:52:35AM +0800, micky wrote:
>> Documentation/printk-formats.txt
>>
>> Raw buffer as a hex string:
>> 	%*ph	00 01 02  ...  3f
>> 	%*phC	00:01:02: ... :3f
>> 	%*phD	00-01-02- ... -3f
>> 	%*phN	000102 ... 3f
>>
>> 	For printing a small buffers (up to 64 bytes long) as a hex string with
>> 	certain separator. For the larger buffers consider to use
>> 	print_hex_dump().
>>
>>
>> Since we can't make sure the cnt value, it is not good use "%*ph",
>> because it must make cnt <= 64.
>> dw_len * 4  <= 64 ?
> Hi Micky,
>
> I think that in these two cases we can rely on print_hex_dump_bytes that
> doesn't have the dev_dbg limit on buffer size.
> Let me know what you think about it. If you agree, I can send a new version
> for patches 3/4 and 4/4, since the first two have already been merged in the
> linux-next tree by Greg.
Hi Fabio,

I think it is good, Thanks.

Best Regards,
micky
> Regards,
> Fabio
> .
>

