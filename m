Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaA2XuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:50:21 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36362 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaA2XuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:50:19 -0500
Message-ID: <52E993B6.9000401@gmail.com>
Date: Thu, 30 Jan 2014 00:50:14 +0100
From: Branimir Maksimovic <branimir.maksimovic@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: latest git usb3.0 ports not working
References: <52DEC0BA.1060007@gmail.com> <20140121221706.GC12657@xanatos> <20140129221121.GE5991@xanatos>
In-Reply-To: <20140129221121.GE5991@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2014 11:11 PM, Sarah Sharp wrote:
> On Tue, Jan 21, 2014 at 02:17:06PM -0800, Sarah Sharp wrote:
>> On Tue, Jan 21, 2014 at 07:47:22PM +0100, Branimir Maksimovic wrote:
>>> asus maximus v gene motherboard,
>>> this is from dmesg:
>>>
>>> [   75.576160] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
>>> [   88.991634] xhci_hcd 0000:03:00.0: Stopped the command ring
>>> failed, maybe the host is dead
>>> [   88.991748] xhci_hcd 0000:03:00.0: Abort command ring failed
>>> [   88.991845] xhci_hcd 0000:03:00.0: HC died; cleaning up
>>> [   93.985489] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
>>> [   93.985494] xhci_hcd 0000:03:00.0: Abort the command ring, but
>>> the xHCI is dead.
>>> [   98.982586] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
>>> [   98.982591] xhci_hcd 0000:03:00.0: Abort the command ring, but
>>> the xHCI is dead.
>>> [  103.979696] xhci_hcd 0000:03:00.0: Timeout while waiting for a slot
>>> [  103.979702] xhci_hcd 0000:03:00.0: Abort the command ring, but
>>> the xHCI is dead.
>> By latest git, do you mean linus/master, or 3.13.0?  If it's
>> linus/master, please provide the commit ID.  Which kernel version worked
>> for you?
> Try reverting commit 7dd09a1af2c7150269350aaa567a11b06e831003 "xhci:
> replace xhci_write_64() with writeq()" and let me know if it worked for
> you.
>
> I would like to help you, but I can't if you don't respond.
>
> Sarah Sharp
Everything is fine after revert. Thanks! usb3.0 is working now.
It is latest repository from linus/master.


