Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaDVLE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:04:58 -0400
Received: from softlayer.compulab.co.il ([50.23.254.55]:56053 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364AbaDVLEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:04:55 -0400
Message-ID: <53564CCA.4070302@compulab.co.il>
Date: Tue, 22 Apr 2014 14:04:42 +0300
From: Denis Turischev <denis.turischev@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mathias Nyman <mathias.nyman@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RESEND] [PATCH] xhci: Switch Intel Lynx Point ports to EHCI
 on shutdown.
References: <532C0E0D.6070107@compulab.co.il> <532C2C36.2030808@linux.intel.com>
In-Reply-To: <532C2C36.2030808@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: -unknown-@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathias,

Just want to remind you about the patch, thanks.

Denis

On 03/21/2014 02:10 PM, Mathias Nyman wrote:
> On 03/21/2014 12:01 PM, Denis Turischev wrote:
>> The same issue like with Panther Point chipsets. If the USB ports are
>> switched to xHCI on shutdown, the xHCI host will send a spurious interrupt,
>> which will wake the system. Some BIOS have work around for this, but not all.
>> One example is Compulab's mini-desktop, the Intense-PC2.
>>
>> The bug can be avoided if the USB ports are switched back to EHCI on
>> shutdown.
>>
> 
> I'll queue this up and send it forward to Greg once 3.15-rc1 is out
> 
> -Mathias
> 
> 

