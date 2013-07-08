Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3GHTMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:12:49 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39489 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:12:48 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130707183158.GA2090@skorgonTP.att.net>
References: <CA+i0qc7p=y0Y1xBk4CVAC47sr09rmaWdtwt2bw8KNFDSpsYYqA@mail.gmail.com>
	<20130707183158.GA2090@skorgonTP.att.net>
Date: Mon, 8 Jul 2013 21:12:47 +0200
Message-ID: <CAKMK7uH4rt1rPDUoMskHzVFsHiO7oRVfoP5X_qw94-gyRnCtcQ@mail.gmail.com>
Subject: Re: Linux 3.10-rc7
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soeren.brinkmann@gmail.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, Shuah Khan <shuah.kh@samsung.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 7, 2013 at 8:31 PM, Sören Brinkmann
<soeren.brinkmann@gmail.com> wrote:
> Hi,
>
> since I updated to 3.10 my system freezes occasionally. Googling the
> messages in my kernel log (attached) make me suspect, that my problem
> might be related to the issue Shuah reported.
>
> So, I just wanted to check in, what the status of this issue is.
>
> In case it helps: I'm on a amd64, 64-bit Arch Linux system running
> kernel 3.10 (vanilla). My machine is a Lenovo T510.
>
> I had to copy the recipient list for this email from some LKML archive
> on the web, apologies if it is not complete.

I only see signs of drm/nouveau, not the i915 driver in your logs. So
definitely something else.

Yours, Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
