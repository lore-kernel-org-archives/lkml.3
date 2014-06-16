Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaFPWOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:14:21 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:42712 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaFPWOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:14:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140616190933.GJ5500@mwanda>
References: <1402785707-12383-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1402785707-12383-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140616190114.GI5500@mwanda>
	<20140616190933.GJ5500@mwanda>
Date: Tue, 17 Jun 2014 00:14:18 +0200
Message-ID: <CAFo99gaUmL1_BYeWSBnzpDFWOoJKmmvhG_wVw-5F9fj-7EpufA@mail.gmail.com>
Subject: Re: [PATCH] staging: ced1401: userspace: use1401.c: Cleaning up
 potential strncpy missing null-terminate
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Monam Agarwal <monamagarwal123@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-16 21:09 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Mon, Jun 16, 2014 at 10:01:14PM +0300, Dan Carpenter wrote:
>>
>> No one calls U14DriverName() so just delete this function.
>
> Oh.  This is a userspace library or something?  I'm not sure what to do.
>
> How did you compile test this?  Does your platform even provide
> strlcpy()?
>
> Anyway, don't delete it like I said, but I still don't think your patch
> helps here.
>
> regards,
> dan carpenter
>

Hi

I saw that these functions are not used, had planned type it in the
cover letter to :-(

Thought of userspec, but then it should definitely ensure the NULL char?

Kind regards
Rickard Strandqvist
