Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaIATB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 15:01:57 -0400
Received: from mxout5.netvision.net.il ([194.90.6.65]:52974 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIATB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 15:01:56 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2014 15:01:56 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <5404C292.9030908@gmail.com>
Date: Mon, 01 Sep 2014 22:01:38 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Tobias Klauser <tklauser@distanz.ch>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: xillybus: Move out of staging
References: <1409471821-11809-1-git-send-email-eli.billauer@gmail.com>
 <20140901123320.GC4707@distanz.ch>
In-reply-to: <20140901123320.GC4707@distanz.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tobias,

Thanks for that heads-up. I'll make a separate patch for MAINTAINERS if 
and when the driver goes out of staging. No point risking the failure to 
apply the major patch because of a clash on MAINTAINERS.

Regards,
    Eli

On 01/09/14 15:33, Tobias Klauser wrote:
>> I shall continue being responsible for its maintenance.
>>      
> In this case a entry in MAINTAINERS would make sense. This way you'll
> make sure patches get submitted to you.
>
>    

