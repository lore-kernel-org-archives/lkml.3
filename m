Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaHKD1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:27:17 -0400
Received: from s87.loopia.se ([194.9.94.112]:51159 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbaHKD1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:27:15 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <53E8385C.8030905@hanshq.net>
Date: Sun, 10 Aug 2014 20:28:28 -0700
From: Hans Wennborg <hans@hanshq.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/19] staging: rtl8192ee: fix %d confusingly prefixed
 with 0x in format strings
References: <1407111658-15236-1-git-send-email-hans@hanshq.net> <20140810042358.GA15249@kroah.com>
In-Reply-To: <20140810042358.GA15249@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 09:23 PM, Greg KH wrote:
> On Sun, Aug 03, 2014 at 05:20:58PM -0700, Hans Wennborg wrote:
>> Signed-off-by: Hans Wennborg <hans@hanshq.net>
>> ---
>>   drivers/staging/rtl8192ee/pci.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> This patch fails to apply to my tree :(
>

Sorry about that. I'll try to rebase and re-post the patch.

  - Hans
