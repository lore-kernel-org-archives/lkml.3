Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3DFGAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 02:00:15 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:42303 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3DFGAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 02:00:13 -0400
Date: Fri, 5 Apr 2013 23:00:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH 1/8] staging: android: binder: replace explicit size types
Message-ID: <20130406060010.GA11127@kroah.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
 <1365078758-28674-2-git-send-email-serban.constantinescu@arm.com>
 <CAMP5Xgd=xT7jcjz4UJY=_V8ccGLJrr6LXpkQCiR8GQCZcDPEDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5Xgd=xT7jcjz4UJY=_V8ccGLJrr6LXpkQCiR8GQCZcDPEDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 04:17:47PM -0700, Arve Hjønnevåg wrote:
> On Thu, Apr 4, 2013 at 5:32 AM, Serban Constantinescu
> <serban.constantinescu@arm.com> wrote:
> >
> > Since the binder driver uses both uint32_t and unsigned int any further
> > kernel changes will be difficult to read. This patch fixes the inconsistent
> > types usage.
> >
> 
> Would it make more sense to only change the types that need to be
> larger on a 64 bit system?

I agree.  You are also changing the type from explicit to "unexplicit",
the exact opposite from what I would be expecting to see here.  Why?
