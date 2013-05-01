Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140Ab3EAWpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:45:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38231 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471Ab3EAWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:45:07 -0400
Message-ID: <51819AED.9090408@linux.vnet.ibm.com>
Date: Wed, 01 May 2013 15:45:01 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mmzone: make holding lock_memory_hotplug() a requirement
 for updating pgdat size
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com> <1367446635-12856-2-git-send-email-cody@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011525580.8804@chino.kir.corp.google.com> <518197E2.7050004@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011539010.8804@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1305011539010.8804@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-3620-0000-0000-00000249C287
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 03:39 PM, David Rientjes wrote:
> On Wed, 1 May 2013, Cody P Schafer wrote:
>
>> They are also initialized at boot without pgdat_resize_lock(), if we consider
>> boot time, quite a few of the statements on when locking is required are
>> wrong.
>>
>> That said, you are correct that it is not strictly required to hold
>> lock_memory_hotplug() when updating the fields in question because
>> pgdat_resize_lock() is used.
>>
>
> I think you've confused node size fields with zone size fields.
>

Where? I'm afraid I don't see where I'm mixing them.


