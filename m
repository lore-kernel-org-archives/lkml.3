Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaH2L7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:59:12 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:51448 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaH2L7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:59:09 -0400
Message-ID: <54006B0A.2050902@cogentembedded.com>
Date: Fri, 29 Aug 2014 15:59:06 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB: Add device quirk for ASUS T100 Base Station
 keyboard
References: <1409286391-2854-1-git-send-email-baolu.lu@linux.intel.com>
In-Reply-To: <1409286391-2854-1-git-send-email-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 8/29/2014 8:26 AM, Lu Baolu wrote:

> This full-speed USB device generates spurious remote wakeup event
> as soon as USB_DEVICE_REMOTE_WAKEUP feature is set. As the result,
> Linux can't enter system suspend and S0ix power saving modes once
> this keyboard is used.

> This patch tries to introduce USB_QUIRK_IGNOR_REMOTE_WAKEUP quirk.

    Why not IGNORE? This doesn't look like a big save...

> With this quirk set, wakeup capability will be ignored during
> device configure.

> This patch could be back-ported to kernels as old as 2.6.39.

> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

WBR, Sergei

