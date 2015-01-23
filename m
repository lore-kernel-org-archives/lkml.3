Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbbAWKPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:15:39 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:43216 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbbAWKPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:15:34 -0500
Message-ID: <54C21F35.1040206@ahsoftware.de>
Date: Fri, 23 Jan 2015 11:15:17 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: provide option to automatically delete the key
 after modules were installed
References: <1421976009-9819-1-git-send-email-holler@ahsoftware.de> <54C21361.1080500@suse.cz> <54C216D8.8040004@ahsoftware.de>
In-Reply-To: <54C216D8.8040004@ahsoftware.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.01.2015 um 10:39 schrieb Alexander Holler:
> Am 23.01.2015 um 10:24 schrieb Michal Marek:
>
>>> +	@rm ./signing_key.priv
>>> +	@rm ./signing_key.x509
>>
>> Why do you need to delete the certificate?
>
> No special reason.
>
> I'm just not sure (and too lazy to look it up) if it might contain the
> private key too (like it's possible in pem files), so I've deleted it too.

Or in other words, while .priv leads me to the educated guess that it 
contains the private key, .x509 doesn't give me an obvious indication 
what it contains.

If someone assures me that .x509 doesn't contain the private key 
necessary to sign the modules, I'll send a v2 of the patch.

Regards,

Alexander Holler
