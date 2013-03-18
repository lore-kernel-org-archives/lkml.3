Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab3CROpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:45:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50838 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab3CROpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:45:21 -0400
Message-ID: <5147286B.9090705@ti.com>
Date: Mon, 18 Mar 2013 10:44:59 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 00/50] staging: omap-thermal: several code refactoring
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com> <20130316090540.GQ9138@mwanda> <5144698B.9080703@ti.com> <20130316161641.GA2630@kroah.com>
In-Reply-To: <20130316161641.GA2630@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Dan,

On 16-03-2013 12:16, Greg KH wrote:
> On Sat, Mar 16, 2013 at 08:46:03AM -0400, Eduardo Valentin wrote:
>> Hello Dan,
>>
>> On 16-03-2013 05:05, Dan Carpenter wrote:
>>> I've reviewed this set.
>>>
>>> I hate to make people redo whole patchset sets, and I hate
>>> re-reviewing code.  Obviously, I don't really like the bunny hop
>>> patches and I'm trying to discourage that going forward.  ;P  But
>>> I wouldn't say it's a "Redo the whole thing" kind of problem.
>>>
>>> Could just resend patch 33 and 47?  You should probably be able to
>>> redo those without changing the rest.
>>
>> I could of course change them if the comment is better clarified. As
>> I mentioned as reply to one of your comments, those changes are
>> following what is suggested in CodingStyle file.
>>
>> I can of course send a diff on top of 33, to fix the introduce bug.
>>
>> For 47, I'm not sure the comment is fully applicable.
>
> As I've taken all of these already (sorry Dan, I was fast and I didn't
> review them as well as you did), you will have to just send incremental
> patches on top of the whole series in order for me to be able to apply
> them.

No issues here, I am going to send soon incremental patches, copying 
Dan, to fix the above mentioned issues on 33 and 47.

>
> thanks,
>
> greg k-h
>
>

