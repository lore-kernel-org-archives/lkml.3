Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3A3ReD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:34:03 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46106 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab3A3ReA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:34:00 -0500
Message-ID: <51095972.9050908@linux.vnet.ibm.com>
Date: Wed, 30 Jan 2013 11:33:38 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: zsmalloc: remove unused pool name
References: <1359560212-8818-1-git-send-email-sjenning@linux.vnet.ibm.com> <51093F43.2090503@linux.vnet.ibm.com> <20130130172159.GA24760@kroah.com>
In-Reply-To: <20130130172159.GA24760@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013017-7182-0000-0000-000004D04B18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 11:21 AM, Greg Kroah-Hartman wrote:
> On Wed, Jan 30, 2013 at 09:41:55AM -0600, Seth Jennings wrote:
>> On 01/30/2013 09:36 AM, Seth Jennings wrote:> zs_create_pool()
>> currently takes a name argument which is
>>> never used in any useful way.
>>>
>>> This patch removes it.
>>>
>>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>>
>> Crud, forgot the Acks...
>>
>> Acked-by: Nitin Gupta <ngupta@vflare.org>
>> Acked-by: Rik van Riel <riel@redhat.com>
> 
> {sigh} you just made me have to edit your patch by hand, you now owe me
> a beer...
> 

Now I owe you a beer and a keyboard.

https://plus.google.com/111049168280159033135/posts/YqyTxk3ujZ8

I'll try to get my act together.

Thanks,
Seth

