Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab3I3EYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 00:24:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59905 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab3I3EYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 00:24:47 -0400
Message-ID: <5248FCCF.7070806@zytor.com>
Date: Sun, 29 Sep 2013 21:23:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix apparent cut-n-paste mistake in Dell reboot workaround.
References: <20130925001344.GA13554@redhat.com> <5245E7B1.2000408@zytor.com> <20130930025733.GA21361@srcf.ucam.org> <5248E8C2.2000108@zytor.com> <20130930030655.GB21361@srcf.ucam.org> <CAPM=9txNWRKPzE=FNz63fi-7mwQq5DvNkVHik4gNodD9WBP9mw@mail.gmail.com>
In-Reply-To: <CAPM=9txNWRKPzE=FNz63fi-7mwQq5DvNkVHik4gNodD9WBP9mw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 08:15 PM, Dave Airlie wrote:
>>
>> Likely indicates that our ACPI reboot handling still isn't bug
>> compatible with Windows. We'd do better fixing that than adding more DMI
>> entries.
> 
> are these only with VTd enabled? I have some Dells that won't reboot
> with VTd turned on, I remember you though it was an acpi bug we
> couldn't do much with.
> 

It would be very interesting to know what the heck the ACPI reset port
is set to in these machines.

	-hpa


