Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab3GKUks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:40:48 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60935 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756612Ab3GKUkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130711113822.GA18579@amd.pavel.ucw.cz>
References: <1372723921.53875.YahooMailNeo@web182202.mail.bf1.yahoo.com> <20130711113822.GA18579@amd.pavel.ucw.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Jul 2013 14:40:26 -0600
Message-ID: <CAErSpo5Jsbh8fcUXt_GL=ihv-3yq1SOD_UejC5MP=jBGowNn_w@mail.gmail.com>
Subject: Re: is it desirable to improve the build system?
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Galeck <mark_galeck@pacbell.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 5:38 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>>
>> Does the Linux-Kernel Community perceive that is the case?
>>
>> If so, do you think it is possible to improve?
>>
>> If so, would such an attempt be welcome, including and especially by, the current maintainer(s) of the build?  Of course it would have to be completely backwards-compatible, including to the text output interface and requirements for modules makefiles.
>>
>
> Yes, speeding up build would be nice. Especially nice would be
> speeding up "empty" build, when only one or two files changed...

The answer to "is it desirable to improve X?" is always "yes."  But
the only way to make progress in Linux is to actually post patches
that "improve X."  This is unlike many corporate environments, where
you might need to get somebody's approval before you even start
trying.  In Linux, there's no such thing as prior approval.  Even if
you could get somebody to say "this looks like a good thing to try,"
that would be no guarantee that subsequent patches would be accepted.

It's hard enough to get people to comment on actual Linux code
changes, i.e., patches.  It's almost impossible to get useful feedback
on proposals without code.

If you posted patches that made significant improvements in build
time, I think people would be very interested.

Bjorn
