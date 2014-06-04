Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaFDOgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:36:33 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33106 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750933AbaFDOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:36:31 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2014 10:36:31 EDT
Message-ID: <538F2EED.9070104@hurleysoftware.com>
Date: Wed, 04 Jun 2014 10:36:29 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>
Subject: Re: [PATCH 1/2] serial: core: Don't drop DTR if system console
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it> <1401891371-4946-1-git-send-email-peter@hurleysoftware.com> <20140604142208.GA1008@kroah.com>
In-Reply-To: <20140604142208.GA1008@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 10:22 AM, Greg Kroah-Hartman wrote:
> On Wed, Jun 04, 2014 at 10:16:10AM -0400, Peter Hurley wrote:
>> If a tty is opened on a serial console, don't drop DTR on
>> last tty close, on tty hangup, or when resetting port hardware
>> via TIOCSSERIAL and TIOCSERCONFIG ioctls.
>>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
>> ---
>>   drivers/tty/serial/serial_core.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> Is this a regression, or something we have never done?

Not sure. I just noticed this was wrong while working on the
other fix.

Regards,
Peter Hurley

