Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaALTEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:04:01 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:60779 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALTD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:03:57 -0500
Message-ID: <52D2E716.8040403@gmail.com>
Date: Sun, 12 Jan 2014 20:03:50 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH RFC 01/10] ARM: s3c64xx: pm: Use name field of generic_pm_domain
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com> <1389469372-17199-2-git-send-email-tomasz.figa@gmail.com> <20140112114717.GA31318@amd.pavel.ucw.cz> <52D287B1.3090106@gmail.com> <20140112185337.GA6810@amd.pavel.ucw.cz>
In-Reply-To: <20140112185337.GA6810@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.01.2014 19:53, Pavel Machek wrote:
> Hi!
>
>>> Could we get some more descriptive names for the domains?
>>
>> They are listed like this in user's manual, e.g. DOMAIN_F, DOMAIN_I,
>> DOMAIN_G, etc.
>
> I guessed so. So the manual sucks. Would it be feasible to get it more
> descriptive (like "Domain_G (GPU)")?

Does the name really matter that much? I changed original ones in this 
patch simply to make it easier to grep for domain related messages in 
kernel output (e.g. dmesg | grep domain). It was not the main part of 
this patch.

Also, there are multiple devices in most domains, so that would rather 
end up being "Domain_I (JPEG, Cam I/F)", "Domain_P (2D, TV Enc., 
Scaler)", "Domain_F (Rot, Post, LCD)".

If you really insist, I can change this, but I fail to see what effect 
it would really have.

Best regards,
Tomasz
