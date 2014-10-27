Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaJ0O7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:59:02 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37502 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaJ0O7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:59:00 -0400
MIME-Version: 1.0
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E8808@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
	<201410150045.53976.marex@denx.de>
	<A765B125120D1346A63912DDE6D8B6315E6D82@NTXXIAMBX02.xacn.micron.com>
	<CACna6rxGzOVu+PKFxHeD7fnhG__3kcM-vY=q8OgtSVgZuQzGwA@mail.gmail.com>
	<A765B125120D1346A63912DDE6D8B6315E8808@NTXXIAMBX02.xacn.micron.com>
Date: Mon, 27 Oct 2014 15:59:00 +0100
Message-ID: <CACna6ryw_izq5n6esFZ2TipL7d6B6YnAJptJrW6za-+ySJN4pw@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: bpqw <bpqw@micron.com>
Cc: Marek Vasut <marex@denx.de>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "shijie8@gmail.com" <shijie8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 October 2014 09:44, bpqw <bpqw@micron.com> wrote:
> Maybe this patch is not very reasonable.But for fix this case,I will develop a new  patch that
> is just used to add extended ID for micron spi nor in the spi_nor_ids[].

Great, I hope it will work on top of the
[PATCH] mtd: spi-nor: prefer more specific entries from chips database
, good luck :)

-- 
Rafał
