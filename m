Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaFWMW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:22:57 -0400
Received: from mx02.posteo.de ([89.146.194.165]:56019 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751695AbaFWMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:22:56 -0400
Message-ID: <53A81BF7.3030207@posteo.de>
Date: Mon, 23 Jun 2014 14:22:15 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black instead
 of native resolution
References: <53A6E72A.9090000@posteo.de> <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-06-23 03:10, schrieb Zhang, Rui:
> 
> 
>> -----Original Message-----
>> From: Martin Kepplinger [mailto:martink@posteo.de]
>> Sent: Sunday, June 22, 2014 10:25 PM
>> To: Zhang, Rui
>> Cc: rjw@rjwysocki.net; lenb@kernel.org; linux-acpi@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Subject: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
>> instead of native resolution
>> Importance: High
>>
>> Since 3.16-rc1 my laptop's just goes black while booting, instead of
>> switching to native screen resolution and showing me the starting
>> system there. It's an Acer TravelMate B113 with i915 driver and
>> acer_wmi. It stays black and is unusable.
>>
>> Do you have other people complain about that? Bisecting didn't lead to
>> a good result. I could be wrong but I somehow suspect the mistake to be
>> somewhere in commit 99678ed73a50d2df8b5f3c801e29e9b7a3e5aa85
>>
> In order to confirm if the problem is introduced by the above commit,
> why not checkout the kernel just before and after this commit and see if the problem exists?
> 
> Thanks,
> rui
> 
So maybe I was wrong. d27050641e9bc056446deb0814e7ba1aa7911f5a is still
good and aaeb2554337217dfa4eac2fcc90da7be540b9a73 is the fist bad one.
This is a big v4l merge. I added the linux-media list in cc now.

What could be the problem here?

> 
>> There is nothing unusual in the kernel log.
>>
>> This is quite unusual for an -rc2. Hence my question. I'm happy to test
>> changes.
>>
>>                                      martin
>> --
>> Martin Kepplinger
>> e-mail        martink AT posteo DOT at
>> chat (XMPP)   martink AT jabber DOT at

