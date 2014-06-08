Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaFHABo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 20:01:44 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:52118 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaFHABn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 20:01:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140607194436.GB5500@mwanda>
References: <1401834219-30682-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140607194436.GB5500@mwanda>
Date: Sun, 8 Jun 2014 02:01:41 +0200
Message-ID: <CAFo99gb+Q37Mo0d+71ON5JGWCrKwGHK+R4bin_m-7TQ1k5AO3g@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: pmgr: dspapi.c: Cleaning up
 uninitialized variable
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sure, no problem!

Glad I could help, and additionally with more than just a two-line fix
this time :-)

Best regards
Rickard Strandqvist


2014-06-07 21:44 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Jun 04, 2014 at 12:23:39AM +0200, Rickard Strandqvist wrote:
>> There is a risk that the variables will be used without being initialized.
>> Has also improved error handling, after an email proposal from Dan Carpenter.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> Looks ok.  This fixes some information leak bugs.  Thanks.
>
> regards,
> dan carpenter
>
