Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbbAGTgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:36:12 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38714 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbbAGTgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:36:11 -0500
Date: Wed, 7 Jan 2015 11:36:07 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Bean Huo =?utf-8?B?6ZyN5paM5paMIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
Cc: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [V7 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Message-ID: <20150107193607.GJ9759@ld-irv-0074>
References: <A765B125120D1346A63912DDE6D8B6315F19EB@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315F19EB@NTXXIAMBX02.xacn.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 07:35:45AM +0000, Bean Huo 霍斌斌 (beanhuo) wrote:
> This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.
> 
> For Micron SPI NOR flash, enabling or disabling quad I/O protocol can be done
> By two methods, which are to use EVCR(Enhanced Volatile Configuration Register)
> and the ENTER QUAD I/O MODE command. There is no difference between these two
> methods. Unfortunately, for some Micron spi nor flashes, there no ENTER Quad I/O
> command(35h),such as n25q064.But for all current Micron spi nor, if it support
> quad I/O mode, using EVCR definitely be supported. It is a recommended method to
> enable Quad I/O mode by EVCR, Quad I/O protocol bit 7.When EVCR bit 7 is reset
> to 0,the SPI NOR flash will operate in quad I/O mode.
> 
> This patch has been tested on N25Q512A and MT25TL256BAA1ESF.Micron spi nor of
> spi_nor_ids[] table all support this method.
> 
> Signed-off-by: bean huo <beanhuo@micron.com>
> Acked-by: Marek Vasut <marex@denx.de>

Pushed to l2-mtd.git. Thanks.

Brian
