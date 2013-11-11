Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3KKSUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:20:41 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:51648 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3KKSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:20:36 -0500
MIME-Version: 1.0
In-Reply-To: <52811DDD.3030609@linux.intel.com>
References: <52811DDD.3030609@linux.intel.com>
Date: Mon, 11 Nov 2013 12:20:35 -0600
Message-ID: <CAMP44s3MkOM99ao3z8h1zbg7mGq6wD7_2ZLiA7UgC+KufhjjPQ@mail.gmail.com>
Subject: Re: make oldnoconfig fix?
From: Felipe Contreras <felipe.contreras@gmail.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, yann.morin.1998@free.fr,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Nov 11, 2013 at 12:11 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:

> Is there a plan to fix 'make oldnoconfig' option?
> I currently have need to it :)

I actually rely on this, but didn't know there was this option, this
is what I've been doing since a long time:

  % echo '' | make oldconfig

But it's very hacky and I see tons of errors reported, but it does
what I expect.

Cheers.

-- 
Felipe Contreras
