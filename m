Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3FDL1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:27:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52472 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3FDL1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:27:31 -0400
Message-ID: <51ADCEF2.40802@ti.com>
Date: Tue, 4 Jun 2013 16:56:42 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Heiko Schocher <hs@denx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: daVinci: remove __init modifier from function declaration
References: <1364816016-29656-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8viYYncvPZ8+qUQ3d87cMKnYz9b1101OoX1KSd_13BrBg@mail.gmail.com>
In-Reply-To: <CA+V-a8viYYncvPZ8+qUQ3d87cMKnYz9b1101OoX1KSd_13BrBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/2013 12:35 PM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> On Mon, Apr 1, 2013 at 5:03 PM, Prabhakar lad
> <prabhakar.csengg@gmail.com> wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch removes the __init modifier from function declaration
>> of all the header files for davinci platform.
>>
> gentle ping for v3.11

Yes, will queue for v3.11

Thanks,
Sekhar
