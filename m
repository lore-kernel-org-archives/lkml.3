Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaKLKDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:03:06 -0500
Received: from michael.mail.tiscali.it ([213.205.33.246]:43206 "EHLO
	michael.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaKLKDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:03:02 -0500
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2014 05:03:02 EST
Message-ID: <54632E58.60709@assyoma.it>
Date: Wed, 12 Nov 2014 10:54:32 +0100
From: Gionatan Danti <g.danti@assyoma.it>
Organization: Assyoma s.r.l.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: g.danti@assyoma.it
Subject: Re: AHCI maximum transfer size
References: <a39687c7cc1c7137f0187aea4ee38676@assyoma.it> <5417FB30.8030908@assyoma.it>
In-Reply-To: <5417FB30.8030908@assyoma.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/2014 10:56, Gionatan Danti wrote:
>> Hi all,
>> I searched the list and the internet for this question, but I did not
>> find a definitive answer.
>>
>> I wonder what is the maximum AHCI transfer size for kernel 2.6.32.x
>> Let me explain: using a command as "dd if=/dev/zero of=/dev/sda bs=2M" I
>> can see, via iostat, that request-size is at 2M (as expected). However
>> it seems to me that the effective transfer size is way lower: disabling
>> writeback cache on the target disk, I see very low performance even for
>> big-chunk transfers.
>>
>> Googling, I found this post on stackoverflow stating that maximum
>> observerd AHCI transfer size (with a SATA protocol analyzer) is 128KB:
>> http://stackoverflow.com/questions/24053662/how-to-enlarge-sata-transfer-size-in-linux-ahci-driver.
>>
>>
>> The stackoverflow post seems to agree with this old LWN.net article:
>> http://lwn.net/Articles/77981/
>>
>> Anyone has any idea of how to find (and eventually change) the used AHCI
>> transfer size without touching the code?
>>
>> NOTE: please CC me directly.
>> Regards.
>>
>
> Hi all,
> any idea on the subject?
>
> Regards.

Hi guys,
anyone with a suggestion?

Thank you.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
