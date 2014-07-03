Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbaGCPmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786AbaGCPmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:42:10 -0400
Message-ID: <53B579B3.8040004@redhat.com>
Date: Thu, 03 Jul 2014 10:41:39 -0500
From: Ken Cox <jkc@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ben Romer <sparmaintainer@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for Jul 3 (staging/unisys)
References: <20140703155305.416bf8c7@canb.auug.org.au> <53B5777C.2050307@infradead.org>
In-Reply-To: <53B5777C.2050307@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 10:32 AM, Randy Dunlap wrote:
> On 07/02/14 22:53, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20140702:
>>
> on x86_64:
>
> CONFIG_UNISYSSPAR=y
> CONFIG_UNISYS_VISORUTIL=m
> # CONFIG_UNISYS_VISORCHANNEL is not set
> CONFIG_UNISYS_CHANNELSTUB=y
>
> drivers/built-in.o: In function `channel_mod_init':
> chanstub.c:(.init.text+0x10a8f): undefined reference to `unisys_spar_platform'
>
>
> because CHANNELSTUB=y and VISORUTIL=m.
Hi Randy,

I have submitted a patch to fix this.

Thanks for the reply.

--
Ken
