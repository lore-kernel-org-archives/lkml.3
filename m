Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaHHSND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:13:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40802 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738AbaHHSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:13:01 -0400
Date: Fri, 8 Aug 2014 15:11:57 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Alexander Shiyan <shc_work@mail.ru>,
        Alexander Holler <holler@ahsoftware.de>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/27] mtd: nand: pxa3xx: show device structure in sysfs
Message-ID: <20140808181157.GA16575@arch.cereza>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <1401142372-14148-10-git-send-email-holler@ahsoftware.de>
 <1401160341.192042842@f271.i.mail.ru>
 <20140808170428.GA6094@arch.cereza>
 <20140808171650.GS3711@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140808171650.GS3711@ld-irv-0074>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08 Aug 10:16 AM, Brian Norris wrote:
> On Fri, Aug 08, 2014 at 02:04:28PM -0300, Ezequiel Garcia wrote:

> > If there's anything left to fix for this driver, please let me know.
> 
> pxa3xx_nand is still missing a parent for its MTD's (mtd->dev.parent). I
> have a follow-up patch queued up locally that I need to send out
> sometime.
> 

Maybe we can trade... you provide the reason for such parent, and I'll cook
a patch in exchange :)

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
