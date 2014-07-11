Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbaGKMnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:43:51 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3887 "EHLO
	esgaroth.tuxoid.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaGKMnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:43:50 -0400
Subject: Re: [PATCH] drivers/staging/comedi/drivers/ni_atmio16d.c: remove
 pointless condition
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        hsweeten@visionengravers.com, dcb314@hotmail.com
Date: Fri, 11 Jul 2014 14:43:12 +0200
In-Reply-To: <CANZNk82rsdbg+zQGQODmNMpScaHZiZ8MeooGWabWZPGwzErCyQ@mail.gmail.com>
References: <1405073603-21468-1-git-send-email-andrey.krieger.utkin@gmail.com>
	 <53BFD1FF.20309@mev.co.uk>
	 <CANZNk82rsdbg+zQGQODmNMpScaHZiZ8MeooGWabWZPGwzErCyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1405082594.21735.1.camel@thorin>
Mime-Version: 1.0
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at 1290; Body=8 Fuz1=8 Fuz2=8
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.2 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fre, 2014-07-11 at 15:30 +0300, Andrey Utkin wrote:
[...]
> Could you please substantiate this? I see that convert_arg has type
> "unsigned int" which may be 8 bytes on 64-bit platform. I haven't

At least in the x86_64 world, "unsigned int" has 32bit.
TTBOMK, it is similar on all other 64bit - otherwise there is no way to
address 32bit ("short int" is usually 16 bit).

	Bernd
-- 
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds

