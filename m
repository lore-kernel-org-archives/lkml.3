Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3EHVcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:32:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2976 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3EHVcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:32:04 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-mNGWZWXaDgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=mDu0LJtoDNUA:10 a=Rea1SEVNW_ZoIBXDLXAA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368048721.7373.70.camel@gandalf.local.home>
Subject: Re: [PATCH] kmsg: honor dmesg_restrict sysctl on /dev/kmsg
From: Steven Rostedt <rostedt@goodmis.org>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Kay Sievers <kay@vrfy.org>,
        LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>
Date: Wed, 08 May 2013 17:32:01 -0400
In-Reply-To: <CAGXu5j+onJqbhEXffXuqjR_-wkQpLJNnH-jqP_zpe4GCoU_8dg@mail.gmail.com>
References: <20130430172541.GA23382@www.outflux.net>
	 <20130508142223.c4497dc285600f30cc56d21a@linux-foundation.org>
	 <CAGXu5j+onJqbhEXffXuqjR_-wkQpLJNnH-jqP_zpe4GCoU_8dg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-08 at 14:26 -0700, Kees Cook wrote:

> Yeah, that'll be fine. I kind of like having the longer rationale in
> the commit message for future reference (i.e. destructive vs
> non-destructive, etc), but I'd rather see the code fixed. :)

There's no reason not to have both, is there?

-- Steve


