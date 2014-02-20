Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaBTENI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 23:13:08 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:36035 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaBTENG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 23:13:06 -0500
MIME-Version: 1.0
In-Reply-To: <20140219152450.GA6141@kroah.com>
References: <1392781773-1941-1-git-send-email-sj38.park@gmail.com> <20140219152450.GA6141@kroah.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Thu, 20 Feb 2014 13:12:34 +0900
Message-ID: <CAEjAsho5dO8VrtUP=jW9QPaSJTiKEdhR5CByk2tJdbxhWM0nwg@mail.gmail.com>
Subject: Re: [PATCH] staging: android: binder: convert commented messages to pr_debug
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osusl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 12:24 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Feb 19, 2014 at 12:49:33PM +0900, SeongJae Park wrote:
>> 2 debugging messages were just commented out for normal case. Let them
>> be activated on debug mode without explicit code modification.
>
> Are you sure this doesn't just always send the messages to the debug log
> all the time now?  Again, I'd just leave it alone...

Yes, I sure it will not unless `DEBUG` defined. I tested it again.

Anyway, I know this patch makes just a little, trivial enhancement and
for somebody, it would not looks like enhancement at all. In these case,
I think maintainer's opinion must be respected.
Also, I agree the code as-is just works and not bad.

Thank you for reviewing and your opinion, Greg.
