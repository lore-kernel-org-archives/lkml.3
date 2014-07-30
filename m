Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaG3MBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:01:18 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:54875 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbaG3MBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:01:16 -0400
Message-ID: <53D8DE75.30306@mev.co.uk>
Date: Wed, 30 Jul 2014 13:00:53 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/19] staging: comedi: amplc_pci230: tidy up a bit
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk> <DC148C5AA1CEBA4E87973D432B1C2D8825F28E5A@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825F28E5A@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-30 01:54, Hartley Sweeten wrote:
> On Tuesday, July 29, 2014 4:58 AM, Ian Abbott wrote:
>>
>> Tidy up the "amplc_pci230" driver a bit.  There are more changes to come
>> after this.  The only one of these that should alter the object code is
>> patch 06, which replaces a udelay() call with usleep_range().
>>
>> 01) staging: comedi: amplc_pci230: reformat a load of comments
>> 02) staging: comedi: amplc_pci230: fix checkpatch line over 80
>>      characters
>> 03) staging: comedi: amplc_pci230: logical continuations should be on
>>      the previous line
>> 04) staging: comedi: amplc_pci230: blank lines aren't necessary before a
>>      close brace '}'
>> 05) staging: comedi: amplc_pci230: alignment should match open
>>      parenthesis
>> 06) staging: comedi: amplc_pci230: usleep_range is preferred over udelay
>> 07) staging: comedi: amplc_pci230: remove unused settling time constants
>> 08) staging: comedi: amplc_pci230: remove PCI230_ADC_CONV
>> 09) staging: comedi: amplc_pci230: remove PCI230_TEST_BIT()
>> 10) staging: comedi: amplc_pci230: add whitespace to register values
>> 11) staging: comedi: amplc_pci230: don't begin line with binary operator
>> 12) staging: comedi: amplc_pci230: omit '!= 0' from logical expressions
>> 13) staging: comedi: amplc_pci230: remove unnecessary braces
>> 14) staging: comedi: amplc_pci230: remove some indentation in
>>      pci230_ai_check_chanlist()
>> 15) staging: comedi: amplc_pci230: no need for '&function'
>> 16) staging: comedi: amplc_pci230: add whitespace to pci230_boards[]
>> 17) staging: comedi: amplc_pci230: no need to initialize named members
>>      to zero
>> 18) staging: comedi: amplc_pci230: tidy up stuct pci230_private
>> 19) staging: comedi: amplc_pci230: remove some unnecessary parentheses
>>
>>   drivers/staging/comedi/drivers/amplc_pci230.c | 1417 +++++++++++++------------
>>   1 file changed, 736 insertions(+), 681 deletions(-)
>
> Other than my comment about patch 13, this looks ok.
>
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

I've posted v2 patches for patches 13 and 19.  Patch 13 v2 is less 
aggressive about brace removal.  Patch 19 is updated to v2 because of 
conflicts with the new patch 13.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
