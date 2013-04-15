Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab3DOHkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:40:17 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53056 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3DOHkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:40:15 -0400
Message-ID: <516BAECB.8060409@linux.vnet.ibm.com>
Date: Mon, 15 Apr 2013 13:09:55 +0530
From: aruna <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jkenisto@linux.vnet.ibm.com,
        mahesh@linux.vnet.ibm.com, anton@samba.org
Subject: Re: [PATCH 1/8] Remove syslog prefix in uncompressed oops text
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420> <20130410072100.20150.74661.stgit@aruna-ThinkPad-T420> <20130415072027.GA30156@concordia>
In-Reply-To: <20130415072027.GA30156@concordia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041507-5564-0000-0000-00000780E3BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 April 2013 12:50 PM, Michael Ellerman wrote:
> On Wed, Apr 10, 2013 at 12:51:00PM +0530, Aruna Balakrishnaiah wrote:
>> Removal of syslog prefix in the uncompressed oops text will
>> help in capturing more oops data.
> Why does it help? Does this effect any existing tools?
>
> cheers
>

By setting the (2nd) syslog argument of kmsg_dump_get_buffer() to false,
we omit <n> line prefixes and thereby capture more of the printk buffer.

No this should not effect any existing tools.


Regards,
Aruna

