Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaFAVFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 17:05:41 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:64663 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFAVFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 17:05:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140601203703.GO17724@mwanda>
References: <1401629315-18843-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140601203703.GO17724@mwanda>
Date: Sun, 1 Jun 2014 23:05:39 +0200
Message-ID: <CAFo99gZEDeXZvdmkESrQ0CSME4wEZ3WSEJmJ-FoJVXOhK=zzcQ@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8192u: r8192U_core.c: Cleaning up
 uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Ana Rey <anarey@gmail.com>, Teodora Baluta <teobaluta@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan

I agree, this looks strange.
Have been looking for a while in history with, to see if the code has
been removed. I start my search using cppcheck for over three months
ago.
But could not find anything. Sorry about that :-(

But I'll make a patch that completely removes testing variable then instead?


Best regards
Rickard Strandqvist


2014-06-01 22:37 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sun, Jun 01, 2014 at 03:28:35PM +0200, Rickard Strandqvist wrote:
>> There is a risk that the variable will be used without being initialized.
>>
>> This was largely found by using a static code analysis program called cppcheck.
>>
>
> I've looked at the code, but I don't see this variable actually used
> anywhere.  What is the exact cppcheck warning message?
>
> regards,
> dan carpenter
>
