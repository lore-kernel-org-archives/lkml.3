Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3IQNgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:36:25 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:64428 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753162Ab3IQNgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:36:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAIBXOFKVhxBY/2dsb2JhbAANTsUngTODGQEBAQQ4QAEQCxgJFg8JAwIBAgFFBg0BBQIBARavXJJPj2cHhB4DrSU
X-IronPort-AV: E=Sophos;i="4.90,923,1371052800"; 
   d="scan'208";a="362724621"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 362724621
X-WN-SMTPAUTHID: gregungerer@westnet.com.au
Message-ID: <52385893.6000802@uclinux.org>
Date: Tue, 17 Sep 2013 23:26:43 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
CC: geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: remove unused Kconfig parameters
References: <1378468779-3289-1-git-send-email-michael.opdenacker@free-electrons.com> <523798BD.9010108@westnet.com.au> <5237C726.9070002@free-electrons.com>
In-Reply-To: <5237C726.9070002@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 17/09/13 13:06, Michael Opdenacker wrote:
> On 09/17/2013 01:48 AM, Greg Ungerer wrote:
>> On 06/09/13 21:59, Michael Opdenacker wrote:
>>> This patch proposes to remove the UC5282 and UC5272 kernel configuration
>>> parameters defined in arch/m68k/Kconfig.machine,
>>> but used nowhere in the makefiles and source code.
>>>
>>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> This change is a subset of c065edde ("remove 16 unused boards in
>> Kconfig.machine") by Pauk Bolle. And that is in 3.12-rc1.
> Awesome! Thank you very much for the good news, and for not applying the
> same change twice. Pfooh, this would have created anti-kconfig
> parameters. Scary. ;)

That would be scary :-)

Regards
Greg



