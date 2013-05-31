Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3EaVqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:46:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59360 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab3EaVp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:45:59 -0400
Message-ID: <51A91A0F.4020408@linux.vnet.ibm.com>
Date: Fri, 31 May 2013 14:45:51 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2]  drivers/base: Use attribute groups to create sysfs
 memory files
References: <51A908A3.7010006@linux.vnet.ibm.com>
In-Reply-To: <51A908A3.7010006@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053121-5806-0000-0000-00002176D7B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 01:31 PM, Nathan Fontenot wrote:
> Update the sysfs memory code to create/delete files at the time of device
> and subsystem registration.
>
> The current code creates files in the root memory directory explicitly through
> the use of init_* routines. The files for each memory block are created and
> deleted explicitly using the mem_[create|delete]_simple_file macros.
>
> This patch creates attribute groups for the memory root files and files in
> each memory block directory so that they are created and deleted implicitly
> at subsys and device register and unregister time.
>
> This did necessitate moving the register_memory() updating it to set the
> dev.groups field.
>
> Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
>
> Please cc me on responses/comments.
>
> v2: refreshed the patch, previous version was corrupted. There is no difference
> otherwise between this patch and the previous one sent out.

Still looks broken. Tabs have been converted into spaces, and the top of 
the patch is whitespace padded to 80 characters.

