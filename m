Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaJBTmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:42:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43471 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104AbaJBTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:42:20 -0400
Message-ID: <542DAA9A.8060503@free-electrons.com>
Date: Thu, 02 Oct 2014 21:42:18 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        gulsah.1004@gmail.com, linux-kernel@vger.kernel.org, pavel@ucw.cz,
        cmroliv@gmail.com,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] staging: nokia_h4: remove deprecated IRQF_DISABLED
References: <1412195628-9522-1-git-send-email-michael.opdenacker@free-electrons.com> <20141001214221.GF26954@drone.musicnaut.iki.fi>
In-Reply-To: <20141001214221.GF26954@drone.musicnaut.iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

Thank you for reviewing my patch!

On 10/01/2014 11:42 PM, Aaro Koskinen wrote:
> Hi,
>
> On Wed, Oct 01, 2014 at 10:33:48PM +0200, Michael Opdenacker wrote:
>> Remove the use of the IRQF_DISABLED flag
>> from drivers/staging/nokia_h4p/nokia_core.c
>>
>> It's a NOOP since 2.6.35 and it will be removed soon.
> This driver has been deleted from the staging tree already.

Ok, good to me too. Thanks again,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

