Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3DWQLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:11:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64445 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab3DWQLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:11:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [PATCH] usb: phy: phy core cannot yet be a module
Date: Tue, 23 Apr 2013 18:11:35 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
References: <1366732475-479886-1-git-send-email-arnd@arndb.de> <1366732475-479886-2-git-send-email-arnd@arndb.de> <20130423160759.GF15177@arwen.pp.htv.fi>
In-Reply-To: <20130423160759.GF15177@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304231811.35692.arnd@arndb.de>
X-Provags-ID: V02:K0:FOScVmeHUCgDIeEMoerrakzIcFrlKip80dJjHGOs+fd
 oPiVRMMdU2KJqjhWWOpy0Vf6wlZC1kPlfjMclQOjdvbGGJZCS5
 XdZE47oiz6Zg9MrlRMCTwmJDev/u6N1DXnFicoNk9W/PQI4dfn
 6WbATaNdCsDugo7Zr/pr58yfEhQFacMH7h9SMEVCv7rGhSVaq5
 FtFoK2pU235bPlcG8mX2BwVkTCMJh2aYNrY3IJiUSTqyqHFP3f
 25sT2fmUI6f3SPzSjWvlWQbMfGijCtrrySL42jutzHXrhi7eYU
 A2O0mnFmizae+5FUBHdkU6wMfGL3Kw8pZjwh/Ss6GrIq6QaQS3
 ZcPEGfq56Hrp3faGGfBo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Felipe Balbi wrote:
> looks like this is the only way, indeed. Do you need on the merge window
> on can this wait until -rc1 ? I just sent a pull request to Greg with
> urgent fixes for the merge window.
> 
> Greg, if you want to take this one as a patch, go for it:
> 
> Acked-by: Felipe Balbi <balbi@ti.com>

It's not relevant for real-life scenarios, it's fine as long as this
makes it into 3.10.

	Arnd
