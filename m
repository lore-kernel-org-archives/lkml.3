Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab3GSTb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:31:28 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55553 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3GSTbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:31:24 -0400
Message-ID: <51E99408.2040106@suse.cz>
Date: Fri, 19 Jul 2013 21:31:20 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: brcm80211-dev-list@broadcom.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: brcm80211: machine freezing hard with rfkill on
References: <51E8E482.30505@suse.cz> <51E93BFA.4090808@broadcom.com>
In-Reply-To: <51E93BFA.4090808@broadcom.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 03:15 PM, Arend van Spriel wrote:
> On 07/19/13 09:02, Jiri Slaby wrote:
>> Hi,
>>
>> our users report [1] that their machines freeze hard when they have
>> rfkill turned on and try to run wpa_supplicant or enable network
>> otherwise. This is with BCM43225 over PCI chip.
>>
>> Any ideas what that could be or how to fix this?
>>
>> [1] https://bugzilla.novell.com/show_bug.cgi?id=787649
>>
>> thanks,
> 
> Hi Jiri,
> 
> Looking in the bug report it seems to be on 3.4 kernel. The commit below
> is done later.

Hi, sorry that I missed this (I thought it was with 3.10) and for the
noise. Thanks for the hint anyway.

-- 
js
suse labs
