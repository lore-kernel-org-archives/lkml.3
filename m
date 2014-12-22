Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaLVRcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:32:41 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63226 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaLVRck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:32:40 -0500
Message-ID: <549855B5.6050805@kernel.dk>
Date: Mon, 22 Dec 2014 10:32:37 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Question about error handling for the function,disk_add_events
 in genhd.c
References: <549854CB.3080707@gmail.com>
In-Reply-To: <549854CB.3080707@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 10:28 AM, nick wrote:
> Greetings Again Jen,
> I am wondering about the fix me message here:
>   /* FIXME: error handling */
> related to error handling. Seems the below code:
>   if (sysfs_create_files(&disk_to_dev(disk)->kobj, disk_events_attrs) < 0)
>                  pr_warn("%s: failed to create sysfs files for events\n",
>                       disk->disk_name);
> handles this fine. I am going to remove the comment unless we need to
> rewrite this function.

Again, spewing a warning when the error triggers and marching is not 
"handles this fine", it only qualifies as "doesn't blatantly ignore an 
error". Please spend some time studying up on what error handling is, 
I'm not even going to look at potential patches or further musings on 
this topic until you have done that.


-- 
Jens Axboe

