Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaD1V6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:58:09 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:47708 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaD1V6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:58:07 -0400
Message-ID: <535ECED3.9020205@mev.co.uk>
Date: Mon, 28 Apr 2014 22:57:39 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] staging: comedi: addi_apci_1032: board has 32 digital
 inputs
References: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com> <1398562623-5727-1-git-send-email-chase.southwood@gmail.com> <DC148C5AA1CEBA4E87973D432B1C2D8825E1F7F8@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825E1F7F8@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/04/14 19:11, Hartley Sweeten wrote:
> On Saturday, April 26, 2014 6:37 PM, Chase Southwood wrote:
>> This board always has 32 digital inputs. Remove the test when
>> initializing the subdevice.
>>
>> Also, since this board is the only one supported by this driver,
>> remove the boardinfo about the digital inputs and just use the
>> data directly in the subdevice init.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
>> ---
>>   drivers/staging/comedi/drivers/addi_apci_1564.c | 26 +++++++++----------------
>>   1 file changed, 9 insertions(+), 17 deletions(-)
>
> Looks good.

Apart from the subject not matching the patch!

(I would have replied to the original, but I seem to have mislaid it.)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
