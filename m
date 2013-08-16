Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3HPKrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:47:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49921 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab3HPKrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:47:04 -0400
Message-ID: <520E0304.5050906@ti.com>
Date: Fri, 16 Aug 2013 13:46:28 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: linux-next: Tree for Aug 15 (usb/phy/phy-am335x-control.c)
References: <20130815165829.6a401f104ee2a98dd48bcb58@canb.auug.org.au> <520D0AD7.6050002@infradead.org>
In-Reply-To: <520D0AD7.6050002@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Sebastian,

On 08/15/2013 08:07 PM, Randy Dunlap wrote:
> On 08/14/13 23:58, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130814:
>>
> 
> on i386 and x86_64:
> 
> drivers/usb/phy/phy-am335x-control.c:45:3: error: implicit declaration of function '__WARN' [-Werror=implicit-function-declaration]
> 
> 

