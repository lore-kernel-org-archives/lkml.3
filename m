Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3FNR10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:27:26 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41080 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab3FNR1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:27:25 -0400
Message-ID: <51BB527A.9050101@linaro.org>
Date: Fri, 14 Jun 2013 10:27:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 0/9 v3] RFC: timekeeping: rtc: change hctosys mechanism
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:52 AM, Alexander Holler wrote:
> Hello,
>
> Because I've become a request which made me slightly more optimistic about
> the RFC patches, I've spend some more time on the patches doing cosmetic.
> I know think the "quickly done" is gone and they might be ready for
> submission.
>
> The whole series consists more or less of 3 mini-series.

In the future, it might be easier if you split the series up into 
separate patchsets. That way it makes the dependencies clear.

For instance, 1-3 I've got no objection to, and 7-9 are getting there, 
but the middle three patches are probably going to need a good bit more 
work.

thanks
-john

