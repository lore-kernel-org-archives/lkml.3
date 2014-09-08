Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaIHMnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:43:19 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:44481 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaIHMnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:43:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140905184821.GB23874@kroah.com>
References: <1409932944-19528-1-git-send-email-voytikd@gmail.com> <20140905184821.GB23874@kroah.com>
From: Dmitry Voytik <voytikd@gmail.com>
Date: Mon, 8 Sep 2014 16:42:56 +0400
Message-ID: <CAAX90H1ToZWJ5WNOtUL+c4no9iuSrzyE+WHJ1SEgyfaajiT2ag@mail.gmail.com>
Subject: Re: [PATCH] staging: binder: cmd_name must be initialised
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 10:48 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Sep 05, 2014 at 08:02:24PM +0400, Dmitry Voytik wrote:
>> Variable cmd_name must be initialised as variable name is.
>
> Why?  What bug does this fix?  Have you tested this change?  Does this
> cause binder to now act differently than before?

Hi Greg,

Thank you for your time.
The intent was to eliminate the GCC warning:
 /scratch/kisskb/src/drivers/staging/android/binder.c: warning:
'cmd_name' may be used uninitialized in this function
[-Wuninitialized]:  => 2275:5
But now after carefull review of the sorce code I've understood that
this is a false positive.
Sorry for bothering.

> thanks,
>
> greg k-h



-- 
Best Regards,
Dmitry Voytik.
voytikd@gmail.com
