Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3CNTce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 15:32:34 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51392 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3CNTcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 15:32:33 -0400
Message-ID: <514225CC.7070903@suse.cz>
Date: Thu, 14 Mar 2013 20:32:28 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: stable <stable@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable request] TTY: do not reset master's packet mode
References: <5141AE1F.40308@suse.cz>
In-Reply-To: <5141AE1F.40308@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 12:01 PM, Jiri Slaby wrote:
> Hi,
> 
> please include the patch below to all maintained stable trees.
> 
> commit b81273a132177edd806476b953f6afeb17b786d5
> Author: Jiri Slaby <jslaby@suse.cz>
> Date:   Tue Jan 15 23:26:22 2013 +0100
> 
>     TTY: do not reset master's packet mode

Just in case, backports for 3.0 and 3.4 are here:
http://kernel.opensuse.org/cgit/kernel/commit/?h=SLE11-SP2&id=5a692081b5562fde6db0b9cc4af07ef828b6f71f
http://kernel.opensuse.org/cgit/kernel/commit/?h=openSUSE-12.2&id=17a7dffd211fb8b8152a91354cf2e44869b2376a

They are just context-fixed though.

> thanks,
-- 
js
suse labs
