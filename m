Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbaFLPKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:10:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26752 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaFLPKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:10:54 -0400
Date: Thu, 12 Jun 2014 18:10:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: nick <nickkrause@sympatico.ca>
Cc: martyn.welch@ge.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, manohar.vanga@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: =?utf-8?B?UEFUQ0hbW3ZtZS9icmlkZ2VzL3Zt?=
 =?utf-8?B?ZV9jYTkxY3g0Mi5jOjEzODI6IEJhZCBpZiB0ZXN0IEJ1ZyBGaXhd4oCP4oCP?=
Message-ID: <20140612151037.GU5500@mwanda>
References: <BLU436-SMTP2404B87A72E455C1BDE2B43A52A0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP2404B87A72E455C1BDE2B43A52A0@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:33:09AM -0400, nick wrote:
> Here is the fixed patch. Having issues with using Thunderbird
> so just used Evolution for now.
> Nick 

Please read the first paragraph of:
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Documentation/email-clients.txt

It's not clear from reading this email why 0 is incorrect and 3<<16 is
correct.  Explain in the changelog.  What are the user visible effects
of this bug etc.

The patch must have a signed-off-by line.

Here is what typical patch emails should look like:
https://lkml.org/lkml/2014/6/12/377
https://lkml.org/lkml/2014/6/12/369
https://lkml.org/lkml/2014/6/12/299

The subject should be:

[PATCH] vme: ca91cx42: Bad if test something something

Make sure it apply with `git am` and review the log.

regards,
dan carpenter


