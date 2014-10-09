Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaJIR23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:28:29 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55131 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJIR2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:28:23 -0400
Date: Thu, 9 Oct 2014 10:28:17 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bcma: Add dependency on OF_ADDRESS
Message-ID: <20141009172817.GC2410@roeck-us.net>
References: <1412872877-1771-1-git-send-email-linux@roeck-us.net>
 <CACna6rzOeGcKrrftLx_3uWe_bAXQaQMmWb3wWHP0CjtdO8D0eg@mail.gmail.com>
 <5436C2B4.6030801@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5436C2B4.6030801@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 07:15:32PM +0200, Arend van Spriel wrote:
> On 10/09/14 18:54, Rafał Miłecki wrote:
> >On 9 October 2014 18:41, Guenter Roeck<linux@roeck-us.net>  wrote:
> >>Commit 2101e533f41a ("bcma: register bcma as device tree driver")
> >>introduces a hard dependency on OF_ADDRESS into the bcma driver.
> >>OF_ADDRESS is specifically disabled for the sparc architecture.
> >>This results in the following error when building sparc64:allmodconfig.
> 
> Does this mean on sparc (using allmodconfig) you will get CONFIG_OF
> and !CONFIG_OF_ADDRESS? Does that makes sense?
> 
> btw. the OF_ADDRESS dependency was introduced by commit "bcma: get
> IRQ numbers from dt".

Looking into the code again: Really ? git blame tells me otherwise.
Also, I don't see the commit you refer to in the upstream kernel.
Maybe I am missing something.

Guenter
