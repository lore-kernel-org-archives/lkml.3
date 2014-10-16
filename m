Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaJPIMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:12:52 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65351 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaJPIMs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:12:48 -0400
MIME-Version: 1.0
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E6F6F@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
	<CACna6rw4g1wWPv+VgL8WeA9rz-j8A6k+4bN7D=MQ9OU-BinToA@mail.gmail.com>
	<A765B125120D1346A63912DDE6D8B6315E6F6F@NTXXIAMBX02.xacn.micron.com>
Date: Thu, 16 Oct 2014 10:12:47 +0200
Message-ID: <CACna6rxNbPzSYbe9GjQCSAeB8FgVi6ZpgKo=AB=6nYc4QcqN1g@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?QmVhbiBIdW8g6ZyN5paM5paMIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
Cc: Brian Norris <computersforpeace@gmail.com>, Marek Vasut <marex@denx.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 October 2014 10:00, Bean Huo 霍斌斌 (beanhuo) <beanhuo@micron.com> wrote:
>>There are a lot of changes happening/requested around this code. I also proposed some patch touching this code, see https://patchwork.ozlabs.org/patch/377917/
>
>>Right now there is a slow ongoing work on fixing some m25p80 regression, which also may touch the code you change. So I'll suggest postponing this patch until we get a regression fixed and then work on this hacky code again.
>
>
> Thanks for your concerns.But for the same deivce id with the different extended id and
> the same device name with the different device id issue, in your patch,this doesn't take
> into account. I have encountered this situation. for example:

I really wasn't looking into details yet and I'm aware my patch does
something else. I just say we should first fix the regression and then
base next patches on top of that regression fix. I'm not NACKing your
changes :)
