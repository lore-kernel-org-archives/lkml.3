Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbaLJNcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:32:21 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41335 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbaLJNcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:32:20 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Wed, 10 Dec 2014 14:32:16 +0100
Message-ID: <1420702.eyL56f8lc9@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <201412101251.30610@pali>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1418155621-21644-4-git-send-email-pali.rohar@gmail.com> <201412101251.30610@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2014 12:51:30 Pali Rohár wrote:
> On Tuesday 09 December 2014 21:07:01 Pali Rohár wrote:
> > Now we have autodetection code for fan multiplier and maximal
> > fan speed so we do not need to have those constants for each
> > laptop in kernel driver code.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > ---
> > !!!Please do not apply this patch until all affected machines
> > will be tested!!!
> > 
> > I tested autodetection code only on Dell Latitude E6440 (where
> > it worked). Other machines which needs to be tested:
> > 
> > Dell Latitude D520
> > Dell Latitude E6540
> > Dell Precision WorkStation 490
> > Dell Studio
> > Dell XPS M140 (MXC051)
> > ---
> 
> Can somebody else with dell laptops test this patch series?
> 
> 

i8k_get_fan_nominal_rpm() returns -22 on my XPS13, so nothing changed
with this patch series applied.

Gabriele
