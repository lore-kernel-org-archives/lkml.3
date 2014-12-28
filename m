Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaL1QCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:02:40 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47859 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaL1QCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:02:39 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Sun, 28 Dec 2014 17:02:35 +0100
Message-ID: <5055106.1nbl2aCxTj@xps13>
User-Agent: KMail/4.14.2 (Linux/3.19.0-rc1+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <201412281648.55076@pali>
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <2326199.sB2oUjFZgt@xps13> <201412281648.55076@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 December 2014 16:48:54 Pali Rohár wrote:
> On Sunday 28 December 2014 16:25:21 Gabriele Mazzotta wrote:
> > On Sunday 28 December 2014 09:46:19 Pali Rohár wrote:
> > > Ok, here are new patches for testing... Those you are still
> > > reading this email thread and have your Dell machines near,
> > > can you test them (ideally with disabling dmi config data)?
> > 
> > Could you please tell me exactly against what should I apply
> > these patches? I can see that they depend on other patches in
> > this thread, but I can't find any tree that includes them.
> > 
> 
> Two patches in previous email could apply on 3.19-rc1 tree.

I see that the second patch you've just sent depends on the followings:
https://patchwork.kernel.org/patch/5524791/ (I8K_SMM_GET_TEMP_TYPE)
https://patchwork.kernel.org/patch/5524731/ (Copyright)

If I'm not wrong, they are not included in 3.19-rc1.
