Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbbAVIgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:36:39 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:54740 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbbAVIga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:36:30 -0500
MIME-Version: 1.0
In-Reply-To: <54C09112.4010306@softplc.com>
References: <54C09112.4010306@softplc.com>
Date: Thu, 22 Jan 2015 09:36:28 +0100
Message-ID: <CAH6sp9P7ET=CFPDaCkcK8gWzUNzp2QFmmT45mDVsb-rVX9x2MQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] 8250_core.c
From: Frans Klaver <fransklaver@gmail.com>
To: Dick Hollenbeck <dick@softplc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 22, 2015 at 6:56 AM, Dick Hollenbeck <dick@softplc.com> wrote:
> This was generated from 3.14 kernel, but since its so small it will likely apply to newer
> kernels without issue.

Thanks for contributing.

It is the custom that you send your patches in the body of the e-mail
instead of as an attachment. You might want to try using git
send-email, or at least have a look at other patch submissions here.

You may also want to make sure that you have a proper subject line to
your patch, like

  8250_core: fix buggy interrupts bit test

  A lesser travelled codepath...

I'm sure you can come up with a better one though.

Before you resubmit, you might want to run scripts/checkpatch.pl on your patch.
If you resubmit, you should probably also put
linux-serial@vger.kernel.org and Greg Kroah-Hartman
<gregkh@linuxfoundation.org> in CC. For a full list of suggestions,
check scripts/get_maintainer.pl.

Good luck,
Frans
