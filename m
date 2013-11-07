Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3KGIGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:06:22 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:37250 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3KGIGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:06:17 -0500
Date: Thu, 7 Nov 2013 09:06:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] perf record: Cleanups and mmap-based output
Message-ID: <20131107080614.GF31926@gmail.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> I know Jiri is working on cleanups of the output file, but had this
> sitting around for a couple of weeks now. Might as well push it out
> for the next baseline. The cleanups of perf-record can be taken
> independently.
> 
> Ingo: I took a look at leveraging the copy_user_nocache and was not able
>       to get it to work. I won't have time to come back to it for a while.
>       Given that the mmap output already improves perf-trace a lot I would
>       like to get the option into 3.13 and come back to the optimization
>       later.

That's OK - your feature is already a big step forward!

1-3 look good to me and 4/4 needs some minor cleanups (see my review 
mail).

Thanks,

	Ingo
