Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaHYQgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:36:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41373 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaHYQgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:36:45 -0400
MIME-Version: 1.0
In-Reply-To: <53FAE383.6050308@t-online.de>
References: <53F9CC77.70009@t-online.de>
	<CA+55aFwZP1gyf=mvTrKjWwj6YE6=5y1+aZdmsNMHUp6d3dckXw@mail.gmail.com>
	<53FAA544.4030401@intel.com>
	<CA+55aFzaHF=S3QQ6M-+JBdWVRCSHKs-jjKo==8OS7q90cUyHBw@mail.gmail.com>
	<53FAE383.6050308@t-online.de>
Date: Mon, 25 Aug 2014 09:36:45 -0700
X-Google-Sender-Auth: NBoZY52jMaAkrLu8N3mRCx4l5Cs
Message-ID: <CA+55aFzUECeazRoX7gRb24WvhOzGAgtm922gvU4qLX+3EZXHDA@mail.gmail.com>
Subject: Re: [Bug 3.14.17] inconsistent lock state
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 12:19 AM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
>
> Testing some other kernels lurking around on the disk I realized that
> after kernel 3.11.5 and before kernel 3.12.9 both the power button
> and "shutdown -h now" lost the ability to power off the machine - the
> system is halted instead and needs a reset / 4 second power button pressing.

Hmm. Does "shutdown -p" work? But it might be interesting to see where
the behavior changed.

           Linus
