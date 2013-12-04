Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab3LDUqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:46:44 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:51964 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3LDUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:46:42 -0500
MIME-Version: 1.0
In-Reply-To: <20131204183554.GA16693@kroah.com>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
	<1386180581-6710-10-git-send-email-serban.constantinescu@arm.com>
	<20131204183554.GA16693@kroah.com>
Date: Wed, 4 Dec 2013 12:46:42 -0800
X-Google-Sender-Auth: faR--8x4NuQNAPTGZg0phJsVeKQ
Message-ID: <CAMbhsRRP=ccdMb5PNwyYab+JoMdh+rmo2qF1naEDGBFCdMz9=A@mail.gmail.com>
Subject: Re: [PATCH v1 9/9] staging: android: binder: Add binder compat layer
From: Colin Cross <ccross@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Butcher <Dave.Butcher@arm.com>, Ian Rogers <irogers@google.com>,
        romlem@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 10:35 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
<snip>

> And finally, is this all really needed?  Why not just fix the structures
> to be "correct", and then fix userspace to use the correct structures as
> well, thereby not needing a compat layer at all?

Some of the binder ioctls take userspace pointers.  Are you suggesting
storing those pointers in a __u64 to avoid having to have a
compat_ioctl?
