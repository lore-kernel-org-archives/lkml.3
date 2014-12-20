Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaLTR1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 12:27:24 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36461 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaLTR1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 12:27:22 -0500
MIME-Version: 1.0
In-Reply-To: <5495AFEE.8030905@roeck-us.net>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com>
	<201412201318.08216@pali>
	<54956F4B.9070401@roeck-us.net>
	<201412201354.46435@pali>
	<5495AFEE.8030905@roeck-us.net>
Date: Sat, 20 Dec 2014 17:27:20 +0000
Message-ID: <CABz95_DzfVFbnQL_8QD=3qdswUYskGsS4k==bgMT596rKHOkuw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] i8k: Autodetect maximal fan speed and fan RPM multiplier
From: Steven Honeyman <stevenhoneyman@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 December 2014 at 17:20, Guenter Roeck <linux@roeck-us.net> wrote:
> I would think that it should be relatively safe
> to assume that the first fan always exists

That would be a bad idea, as this is definitely not the case:

i8k-virtual-0
Adapter: Virtual device
fan2:        3181 RPM
CPU:          +43.0°C
Ambient:      +42.0°C
SODIMM:       +36.0°C


Thanks,
Steven
