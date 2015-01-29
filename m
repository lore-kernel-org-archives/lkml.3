Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbbA2NB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:01:57 -0500
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:35779 "EHLO
	smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbbA2NB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:01:56 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA2F41.8060602@mev.co.uk>
Date: Thu, 29 Jan 2015 13:01:53 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: dt2814: Removed variables that
 is never used
References: <1422484430-8686-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <54CA2CFF.7080203@mev.co.uk>
In-Reply-To: <54CA2CFF.7080203@mev.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/15 12:52, Ian Abbott wrote:
> On 28/01/15 22:33, Rickard Strandqvist wrote:
>> Variable ar assigned a value that is never used.
>> I have also removed all the code that thereby serves no purpose.
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>> ---
>>   drivers/staging/comedi/drivers/dt2814.c |   13 ++++---------
>>   1 file changed, 4 insertions(+), 9 deletions(-)
>
> Good, apart from the bad English!
>
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

On second thoughts, I retract my 'Reviewed-by'. The patch actually 
serves to point out a glaring bug in the original code, in that it 
acquires data in the interrupt routine but just throws it all away!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
