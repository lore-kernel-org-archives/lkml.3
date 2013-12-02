Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab3LBNhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:37:13 -0500
Received: from nm16-vm6.bullet.mail.ne1.yahoo.com ([98.138.91.109]:38284 "HELO
	nm16-vm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751515Ab3LBNhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:37:08 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Dec 2013 08:37:08 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 342666.54328.bm@omp1041.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=tTLpYlKnAH7xSYNtGNl1YDc+MN6WMLhZ8TECMNxjL7OANo8yZ8iruEKxGRuPlpx4A5CeteWr9Pvx2nDNp+EkhL+nuwqyVuUmHIMN6rtlm252GXAilvfCdek5Ytx5pPGBFyIqviw8THGi3+z7Osc1xePY4ivbV121i+iTA2/BINQ=;
X-YMail-OSG: 63vu_4MVM1m36gwareLD3I9QkM7Oqde7yku4CjYG5XEW95p
 nRRvoNNvWyiY5oAd_yLx2DUehj948o_Q7BtLChmeIuAqGJru1WkTHZUgcO1s
 iEpFxyDMzNsOG_aRz7EhhmNMhCsfew8YzrgOvorYHV7gL1i7RD6fNxfgb7eB
 BYDQcPoXGhtiIPCrrGwJKH82rKhkGl8O71OSwYqOphpp8l_3rR.Z0tilPgfv
 wVDEaX2VUGDwarzreE9WpwiUDp1RdLHYR1egLl_AwQRJIoXB.pF2w_uFEKDP
 bWEqpgDBRZ3DYJQTGhEa0rcQkptR.idopg2FNOP6Fd2nUB0QWDum75AJdd0y
 rYxNQJLhghCayc0ZMNiYlLmEKShppXTiF5AVet1mm2WaKfZV9WsSfZUEdt3y
 KwjWx67uZ2oUZy9WmprNvn2EsO_qlU3JbYMZwvXzoXjT1oVeIsVxsr_PqIxc
 gEZ2Sv7kPgS4N2SG8_AqY1ASb3hsDDSFDvgxF6bsNASZg13oRvSKzj7sWgRD
 6Tou1fvwxi5wMnl6kp.pgZxTFYBLJ1rUuEEYp2v5j8l9WM2cK4dNWKvQhmLO
 W36F2KentR2zEfKemCXxp8PwAXwybAtY0PIY-
X-Rocket-MIMEInfo: 002.001,CgoKPk9uIFN1bmRheSwgRGVjZW1iZXIgMSwgMjAxMyA4OjQzIFBNLCBBbGV4IERhdmlzIDxhbGV4MTQ2NDFAeWFob28uY29tPiB3cm90ZToKPkkgaGF2ZSBhIERlbGwgSW5zcGlyb24gTjcwMTAgTGFwdG9wIHdpdGggSW50ZWwgZ3JhcGhpY3MuIFdoZW4gdGhlIGRlbGwtbGFwdG9wIG1vZHVsZSBpcyA.bG9hZGVkLAo.dHdvIGJhY2tsaWdodCBkZXZpY2UgZGV2aWNlcyBhcmUgY3JlYXRlZDsgZGVsbF9iYWNrbGlnaHQsIGFuZCBpbnRlbF9iYWNrbGlnaHQgZnJvbSB0aGUgPkludGVsCj5ncmFwaGljcyBkcml2ZXIBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.167.602
References: <1385948627.51494.YahooMailNeo@web160404.mail.bf1.yahoo.com>
Message-ID: <1385991037.32894.YahooMailNeo@web160406.mail.bf1.yahoo.com>
Date: Mon, 2 Dec 2013 05:30:37 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [PATCH 1/1] dell_laptop: add disable_backlight module parameter
To: "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1385948627.51494.YahooMailNeo@web160404.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




>On Sunday, December 1, 2013 8:43 PM, Alex Davis <alex14641@yahoo.com> wrote:
>I have a Dell Inspiron N7010 Laptop with Intel graphics. When the dell-laptop module is >loaded,
>two backlight device devices are created; dell_backlight, and intel_backlight from the >Intel
>graphics driver. The dell_backlight device is non-functional, but the graphics subsystem >uses
>it instead of the functioning intel_backlight device. The result is that, when running >KDE,
>screen dimming does not work. I've added a module parameter, disable_backlight, which when 
>true will disable the dell_backlight device, and leave only the intel_backlight: with >this,
>screen dimming works.
>
>Signed-off-by: Alex Davis <alex14641@yahoo.com>

This patch is against 3.10.

