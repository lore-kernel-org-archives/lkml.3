Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbaGCSIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:08:15 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:53991 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaGCSIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:08:14 -0400
MIME-Version: 1.0
In-Reply-To: <1404410691.16291.11.camel@x220>
References: <1404354994-7478-1-git-send-email-xerofoify@gmail.com>
	<1404410691.16291.11.camel@x220>
Date: Thu, 3 Jul 2014 14:08:13 -0400
Message-ID: <CAPDOMVh0qyjq11kKaO2ndYhLW8j+dZyv3-c89BBcO1AxY+fiHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mach-spear: fixed spear1340.c file
From: Nick Krause <xerofoify@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes it is and I did it in two patches in order to be more readable.
Furthermore I don't known Kconfig well enough to do the Makefile
for the file I created.
Cheers Nick

On Thu, Jul 3, 2014 at 2:04 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Wed, 2014-07-02 at 22:36 -0400, Nicholas Krause wrote:
>> This is the fixed file after moving sata support to new file in
>> spear1340_sata.c
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  arch/arm/mach-spear/spear1340.c | 111 ----------------------------------------
>>  1 file changed, 111 deletions(-)
>
> This patch, together with patch 1/2, basically moves a chunk of code
> into a separate file, didn't it? If so, why did you split that move in
> two patches?
>
> And how does all this work without any changes to a Makefile?
>
>> diff --git a/arch/arm/mach-spear/spear1340.c b/arch/arm/mach-spear/spear1340.c
>> index 7b6bff7..f9d8ef3 100644
>> --- a/arch/arm/mach-spear/spear1340.c
>> +++ b/arch/arm/mach-spear/spear1340.c
>> @@ -21,117 +21,6 @@
>>  #include "generic.h"
>>  #include <mach/spear.h>
>>
>> -/* FIXME: Move SATA PHY code into a standalone driver */
>
> (I have no idea what this FIXME is about, but I do wonder whether that
> new file by itself is the standalone driver this FIXME is about. The
> spear developers will surely know.)
>
>
> Paul Bolle
>
