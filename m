Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbbASOaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:30:15 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:59583 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbASOaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:30:10 -0500
MIME-Version: 1.0
In-Reply-To: <54BCC153.5060804@gmail.com>
References: <54AFCE4A.80804@gmail.com>
	<CANq1E4ScALBHtN5B_1N0ynKFx4HwZaQZNg3RAv4tcn10YLHtAA@mail.gmail.com>
	<54BCC153.5060804@gmail.com>
Date: Mon, 19 Jan 2015 15:30:10 +0100
Message-ID: <CANq1E4TATDWEZDbDk85BN6kQw8ZSiZJ_eSubUaFTkhQm8URMcA@mail.gmail.com>
Subject: Re: File sealing man pages for review (memfd_create(2), fcntl(2))
From: David Herrmann <dh.herrmann@gmail.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Florian Weimer <fweimer@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        "Carlos O'Donell" <carlos@systemhalted.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Jan 19, 2015 at 9:33 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> [...]
>
> By the way, I forgot to say that I also added this error under ERRORS:
>
> [[
> .TP
> .B EINVAL
> .I cmd
> is
> .BR F_ADD_SEALS
> and
> .I arg
> includes an unrecognized sealing bit or
> the filesystem containing the inode referred to by
> .I fd
> does not support sealing.
> ]]
>
> Look okay?

I thought I already mentioned that somewhere.. eh, seems I didn't :) Looks good!

>> Both man-pages look really good. Thanks a lot!
>
> You're welcome. Thanks for the initial drafts, and this review.
> The changes will go out with the next man-pages release.

Perfect! Thanks Michael!
David
