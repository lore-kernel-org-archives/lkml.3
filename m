Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362Ab3JPTEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 15:04:55 -0400
Received: from mxout7.netvision.net.il ([194.90.6.2]:35236 "EHLO
	mxout7.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760800Ab3JPTEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 15:04:54 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2013 15:04:54 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <525EDFAF.8030306@gmail.com>
Date: Wed, 16 Oct 2013 21:49:19 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dhanunjaya <dhanunjaya.matrix@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: xillybus: fix for quoted string split across
 lines
References: <1381946272-18651-1-git-send-email-dhanunjaya.matrix@gmail.com>
 <20131016180627.GA17116@kroah.com>
In-reply-to: <20131016180627.GA17116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On 16/10/13 21:06, Greg KH wrote:
>>   	rc = of_address_to_resource(dev->of_node, 0,&endpoint->res);
>> >    	if (rc) {
>> >  -		pr_warn("xillybus: Failed to obtain device tree "
>> >  -			"resource\n");
>> >  +		pr_warn("xillybus: Failed to obtain device tree resource\n");
>>      
> This should be using dev_warn() instead.
>
>    

So I understand that I should replace *all* occurrences of pr_warn() and 
pr_err() with their dev_* counterparts?

If so, please give me a week or so to handle that. It's going to be 
rather chunky patch...

Regards,

    Eli

