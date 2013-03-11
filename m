Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3CKX6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:58:54 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:53998 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3CKX6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:58:51 -0400
MIME-Version: 1.0
In-Reply-To: <513E2D56.8070902@ladisch.de>
References: <1362973920-4942-1-git-send-email-helstroom@google.com>
	<513D968C.1060905@ladisch.de>
	<CAOcFWma6fMqwqzMxFfCM7hOqk04FBk9JkKZjwekki_GFUR2jSQ@mail.gmail.com>
	<513E2D56.8070902@ladisch.de>
Date: Mon, 11 Mar 2013 16:58:51 -0700
Message-ID: <CAOcFWmaMxMwFDuWA4tHPUEeOvGT+QtFvHYHe7wk5jzUEWm0VPQ@mail.gmail.com>
Subject: Re: [PATCH][RESEND] Add a USB audio quirk for the NuForce UDH-100 device.
From: Dave Helstroom <helstroom@google.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: perex@perex.cz, tiwai@suse.de, eldad@fogrefinery.com, damien@zamaudio.com,
        Pete Leigh <pete.leigh@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 March 2013 12:15, Clemens Ladisch <clemens@ladisch.de> wrote:
>
> >> David Helstroom wrote:
> >>> Interface 1 does not exist
>
> Please try the patch below.

This works great for me -- thanks a lot!

My only suggestion (from a kernel newbie so feel free to ignore),
would be that it might be worthwhile even walking the entire set of
ifaces in case some other firmware decides to put the IAD even further
down the interface list. However you're obviously much better placed
as to the likelihood/worth of that occurring. Thanks again!
