Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaJBUTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:19:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43647 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751885AbaJBUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:19:32 -0400
Message-ID: <542DB350.3080707@free-electrons.com>
Date: Thu, 02 Oct 2014 22:19:28 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: sre@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HSI: remove deprecated IRQF_DISABLED
References: <1412195335-9437-1-git-send-email-michael.opdenacker@free-electrons.com> <20140912143722.GA22420@xo-6d-61-c0.localdomain>
In-Reply-To: <20140912143722.GA22420@xo-6d-61-c0.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2014 04:40 PM, Pavel Machek wrote:
> On Wed 2014-10-01 22:28:55, Michael Opdenacker wrote:
>> Remove the use of the IRQF_DISABLED flag
>> from drivers/hsi/clients/nokia-modem.c
>>
>> It's a NOOP since 2.6.35 and it will be removed soon.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks! Wow, you have a nice system date, writing from the past (Sep. 12).

Mike.


-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

