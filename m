Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaF2KvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 06:51:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:52481 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbaF2KvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 06:51:09 -0400
Message-ID: <53AFF01A.2010307@kernel.org>
Date: Sun, 29 Jun 2014 11:53:14 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Guillaume Morin <guillaume@morinfr.org>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org, mwelling@ieee.org
Subject: Re: [PATCH v4 1/1] staging: iio: ad9850.c: code cleanup
References: <936f1ac494ee8708e37a8cb16a70aa3f007e93cd.1403966025.git.guillaume@morinfr.org> <20140628160316.GB11019@kroah.com>
In-Reply-To: <20140628160316.GB11019@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/14 17:03, Greg KH wrote:
> On Sat, Jun 28, 2014 at 05:54:39PM +0200, Guillaume Morin wrote:
>> checkpath.pl was complaining about value_mask:
>> ERROR: Macros with complex values should be enclosed in parenthesis
>>
>> I fixed this by simply removing it since it's not used (as well as another
>> macro).  Got rid of the un-necessary error_ret label as well.
>>
>> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
>> Reported-by: Michael Welling <mwelling@ieee.org>

>> ---
>> Changes since v3:
>> - Added Reported-by: Michael Welling <mwelling@ieee.org>
>>
>>   drivers/staging/iio/frequency/ad9850.c |    6 ------
>>   1 file changed, 6 deletions(-)
>
> Very good, thanks for pushing through and doing this.
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
Applied to the togreg branch of iio.git

Thanks,
