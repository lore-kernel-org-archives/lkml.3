Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966737AbaFTKqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 06:46:35 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47698 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966374AbaFTKqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 06:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140616090525.GG5500@mwanda>
References: <1402852858-1352-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140616090525.GG5500@mwanda>
Date: Fri, 20 Jun 2014 12:46:33 +0200
Message-ID: <CAFo99gY+UQQdTiRzF8Ca9tYzcty90yHQ3paR9-67tYHcr_JZhQ@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8712: rtl871x_ioctl_linux.c: Cleaning up
 useless if statement
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Cort <linuxgeek@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It's a bit confusing with this, I have received a lot of complaints
that I have not had a cover letter.
When should I include it? In an obvious patching. But where there's a
need to explain anything further should have a cover letter.

In this case, I suspected that there is a missed special case, that I
mentioned in the cover letter.
But did my patch that otherwise took away the otherwise unnecessary
code.  Thought it was the right use...?



Kind regards
Rickard Strandqvist


2014-06-16 11:05 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sun, Jun 15, 2014 at 07:20:57PM +0200, Rickard Strandqvist wrote:
>> The same code regardless of the outcome of the if statement. This may of
>> course be a miss and there should be a difference in the code.
>> And clean up another duplicate line of code.
>>
>> This was partly found using a static code analysis program called cppcheck.
>>
>
> We don't need a cover letter for a single patch.  Just put this stuff in
> the patch description next time.
>
> regards,
> dan carpenter
>
