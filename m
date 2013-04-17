Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966111Ab3DQLe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:34:28 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:56616 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965882Ab3DQLe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:34:26 -0400
Subject: Re: Cannot add new efi boot entry
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, matthew.garrett@nebula.com,
        cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        Tony Luck <tony.luck@intel.com>, linux-efi@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <516D23B5.4070209@intel.com>
References: <516B1ED3.9040900@suse.cz>
	 <1366106168.23707.9.camel@linux-s257.site>  <516D23B5.4070209@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Apr 2013 19:33:17 +0800
Message-ID: <1366198397.23707.68.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2013-04-16 於 11:11 +0100，Matt Fleming 提到：
> On 16/04/13 10:56, joeyli wrote:
> > I think I just got the same situation on my side with Acer machine. I am
> > trying Matthew's new patchset hope can avoid this situation:
> > 
> > https://lkml.org/lkml/2013/4/15/473
> 
> Please do let us know whether the patches work for you.
> 
> 

I applied Matthew's patches to v3.9-rc7 then tested...

The active_size checking works to me on my Acer machine for avoid the
storage_size/2 issue, I can use efibootmgr to create new boot entry,
now.

But, I found there have the following warning:

[    1.347581] [Firmware Bug]: efi: Inconsistent initial size

Then, I add printk to print the values of var_size and active_size,
found the values always 0 after system reboot. I am doing to add more
log for locate if this is a BIOS issue.


Thanks a lot!
Joey Lee



