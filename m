Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3LDVn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:43:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3LDVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:43:27 -0500
Date: Wed, 4 Dec 2013 13:43:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@android.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Rogers <irogers@google.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, romlem@android.com,
        David Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
Message-ID: <20131204214325.GA19565@kroah.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
 <1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
 <20131204183554.GA16693@kroah.com>
 <CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 12:46:42PM -0800, Colin Cross wrote:
> On Wed, Dec 4, 2013 at 10:35 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> <snip>
> 
> > And finally, is this all really needed?  Why not just fix the structures
> > to be "correct", and then fix userspace to use the correct structures as
> > well, thereby not needing a compat layer at all?
> 
> Some of the binder ioctls take userspace pointers.  Are you suggesting
> storing those pointers in a __u64 to avoid having to have a
> compat_ioctl?

Yes, that's the best way to solve the issue, right?

thanks,

greg k-h
