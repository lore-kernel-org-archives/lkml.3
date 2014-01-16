Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaAPSMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:12:55 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:61610 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaAPSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:12:52 -0500
MIME-Version: 1.0
In-Reply-To: <52D81C92.9050800@canonical.com>
References: <52D81C92.9050800@canonical.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 16 Jan 2014 11:12:32 -0700
Message-ID: <CAErSpo64e52Vv8bJ54cPcpnZ=OHMaxt2-D6dA4HCrrLnKo1n7g@mail.gmail.com>
Subject: Re: [v3.11][v3.12][v3.13][Regression] EISA: Initialize device before
 its resources
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 10:53 AM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> Hi Bjorn,
>
> A kernel bug was opened against Ubuntu [0].  After a kernel bisect, it
> was found the following commit introduced this bug:

Sorry about that, and thanks for the report.  Did you mean to include
URL for the bug?

> commit 26abfeed4341872364386c6a52b9acef8c81a81a
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date: Mon Apr 15 14:34:02 2013 -0600
>
>     EISA: Initialize device before its resources
>
> The regression was introduced as of v3.10-rc1.
>
> Reverting this commit has resolved the bug.  I wanted to get your
> feedback, since you are the patch author.  Should we consider reverting
> this commit in mainline and the stable trees?
>
> Thanks,
>
> Joe
>
