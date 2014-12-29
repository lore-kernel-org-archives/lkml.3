Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaL2Mu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:50:26 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34075 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaL2MuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:50:25 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Mon, 29 Dec 2014 13:50:22 +0100
Message-ID: <1452807.aaSs3acGZG@xps13>
User-Agent: KMail/4.14.2 (Linux/3.19.0-rc1+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <201412291322.52203@pali>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1566138.nEi3x1Fh8B@xps13> <201412291322.52203@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2014 13:22:52 Pali Rohár wrote:
> On Sunday 28 December 2014 17:17:14 Gabriele Mazzotta wrote:
> > OK, I wanted to double check in case I had something missing.
> > 
> > Patches tested on my XPS13: the correct values for fan_mult
> > and fan_man are automatically selected.
> 
> Great. Are there any other problems? Now probe time when loading 
> module should be lower and could not freeze system, right?

Yes, the system doesn't hang on module load. The only problem I have
right night now is that the system temporarily hangs when I read or set
the speed of the fan.
