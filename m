Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3CPMtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 08:49:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38066 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab3CPMta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 08:49:30 -0400
Message-ID: <51446A50.9070701@ti.com>
Date: Sat, 16 Mar 2013 08:49:20 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 33/50] staging: omap-thermal: refactor APIs handling threshold
 values
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com> <1363352438-15935-34-git-send-email-eduardo.valentin@ti.com> <20130316083952.GO9138@mwanda>
In-Reply-To: <20130316083952.GO9138@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-03-2013 04:39, Dan Carpenter wrote:
> On Fri, Mar 15, 2013 at 09:00:21AM -0400, Eduardo Valentin wrote:
>>   	if (ret) {
>>   		dev_err(bg_ptr->dev, "failed to read thot\n");
>> -		return -EIO;
>> +		ret = -EIO;
>> +		goto exit;
>>   	}
>>
>> -	*thot = temp;
>> +	*val = temp;
>>
>> +exit:
>>   	return 0;
>>   }
>
>
> The bunny hop has introduced a bug and this always returns success.

What was the bug introduced?

I will send a patch to fix the return value.

>
> regards,
> dan carpenter
>
>
>

