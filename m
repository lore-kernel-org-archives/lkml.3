Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBJEEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:04:34 -0500
Received: from blu0-omc2-s22.blu0.hotmail.com ([65.55.111.97]:8883 "EHLO
	blu0-omc2-s22.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742AbaBJEEc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:04:32 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 23:04:32 EST
X-TMN: [VbwCA1qQDq0QQKErjMdKtwiBP7wSjkq1]
X-Originating-Email: [yuhongbao_386@hotmail.com]
Message-ID: <BLU177-W291F3CD8A955C71C799C8C3900@phx.gbl>
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>
CC: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Linux, UEFI, and Chromebooks (was RE: [PATCH 0/4] EFI 1:1 mapping)
Date: Sun, 9 Feb 2014 19:59:25 -0800
Importance: Normal
In-Reply-To: <20130603164237.GA23146@srcf.ucam.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <20130602225620.GA5496@srcf.ucam.org> <20130603081148.GB13607@nazgul.tnic>
 <1370269642.2910.4.camel@dabdike> <20130603143010.GA20252@srcf.ucam.org>
 <1370270282.2910.9.camel@dabdike>
 <20130603152122.GA21312,<20130603164237.GA23146@srcf.ucam.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 10 Feb 2014 03:59:25.0986 (UTC) FILETIME=[7D444020:01CF2614]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jun 03, 2013 at 09:35:07AM -0700, James Bottomley wrote:
>> On Mon, 2013-06-03 at 17:24 +0100, Matthew Garrett wrote:
>>> That seems optimistic. Windows never calls QueryVariableInfo() during
>>> boot services, so what makes you think doing so has ever been tested?
>>
>> It's used by the UEFI shell package ... every system which boots to the
>> shell automatically tests this. I know no locked down UEFI system ships
>> with a shell but almost every system in test has a Shell in some form,
>> so I think its fairly safe to call it from boot services.
>
> Why do you persist in this belief that all system vendors are going to
> have run a shell, let alone any kind of test suite? That runs counter to
> everything we've learned about x86 firmware. People verify that it runs
> Windows and then ship it.
What is frustrating here is that Google decided that x86 Chromebooks should use different firmware, otherwise it would be easier to convince vendor to fix these firmware bugs.

Yuhong Bao 		 	   		  