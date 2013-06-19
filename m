Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934947Ab3FSUTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:19:42 -0400
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:36581
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab3FSUTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:19:40 -0400
X-Originating-IP: [86.2.11.244]
X-Spam: 0
X-Authority: v=2.0 cv=RN7rhPe+ c=1 sm=1 a=n6O9K/ebToSnNVE6TGWEMw==:17
 a=xFrwVLZJWjEA:10 a=NeM3mFqpoN0A:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10
 a=NLZqzBF-AAAA:8 a=eQPKN83LY6YA:10 a=NUpyhFhM5mD7V6ozJkMA:9 a=wPNLvfGTeEIA:10
 a=_dQi-Dcv4p4A:10 a=n6O9K/ebToSnNVE6TGWEMw==:117
Message-ID: <51C21253.2070308@ntlworld.com>
Date: Wed, 19 Jun 2013 21:19:31 +0100
From: Stephen Moorby <steve.moorby@ntlworld.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jiri@resnulli.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/net: param for lapbether for specific ethernet
 device
References: <1371655613-31969-1-git-send-email-steve.moorby@ntlworld.com> <20130619.121802.2112053686285060471.davem@davemloft.net>
In-Reply-To: <20130619.121802.2112053686285060471.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will be using an Ubuntu 10.04 kernel with the 'eth_dev' module 
parameter patch.  I appreciate a better solution needs to be designed 
but it is not one I can contribute to.  I still advocate the patch as an 
improvement on the current non functional situation.

On 19/06/13 20:18, David Miller wrote:
> From: Stephen Moorby <steve.moorby@ntlworld.com>
> Date: Wed, 19 Jun 2013 16:26:53 +0100
>
>> The lapbether driver binds to the first ethernet device that comes up.
>> This causes problems in hardware with multiple ethernet interfaces,
>> potentially resulting in the LAPB traffic on the wrong interface.
>> Have added a module parameter 'eth_dev' to specify the ethernet
>> interface over which lapbether should operate.  The module behaves
>> as before if no device is specified.
>>
>> Patch created on linux-next 18-Jun-2013.
>> Tested on 2.6.32-45-generic.
>>
>> Signed-off-by: Stephen Moorby <steve.moorby@ntlworld.com>
> I rejected this patch last night, stating that module parameters are
> deeply discouraged and therefore you need to create a runtime mechanism
> to control this.
>

