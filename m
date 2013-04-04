Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab3DDMcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:32:54 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:60478 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780Ab3DDMcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:32:51 -0400
Message-ID: <1365078767.9806.34.camel@host5.omatika.ru>
Subject: Re: [PATCH v2] wait while adding MMC host to ensure root mounts
From: Sergey Yanovich <ynvich@gmail.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chris Ball <cjb@laptop.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Date: Thu, 04 Apr 2013 16:32:47 +0400
In-Reply-To: <515D6568.7000702@intel.com>
References: <1363223183-3772-1-git-send-email-ynvich@gmail.com>
	   <1363224194-7366-1-git-send-email-ynvich@gmail.com>
	   <87620jmkoe.fsf@octavius.laptop.org>
	   <CAPDyKFp27MUOjhydLXf92vN3cua=XcX4oTJnMGfOJPpBhtwM8Q@mail.gmail.com>
	   <87ppylf429.fsf@octavius.laptop.org> <515ADEDE.3050707@intel.com>
	  <1364912689.3399.7.camel@host5.opentask.org> <515D1F4E.1080306@intel.com>
	 <1365073152.9806.26.camel@host5.omatika.ru> <515D6568.7000702@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 14:35 +0300, Adrian Hunter wrote:
> On 04/04/13 13:59, Sergey Yanovich wrote:
> > On Thu, 2013-04-04 at 09:35 +0300, Adrian Hunter wrote:
> >> No,  I am booting from eMMC.
> > 
> > Well, in this case you should be aware, that your system is not
> > concurrency-safe without the patch. It may or may not boot each time
> > depending on the large number of factors.
> 
> Not true.  You know nothing of my boot time characteristics.

Well, I assumed you use linux kernel recent enough to include the patch
in question. This assumption may well be wrong.

Could you please elaborate how you avoid a situation which brought up
this patch ("all probes finish and mmc card is not ready")?

