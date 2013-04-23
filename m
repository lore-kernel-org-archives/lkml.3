Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3DWSyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:54:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:37253 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab3DWSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:54:19 -0400
Message-ID: <5176D8C3.5020701@infradead.org>
Date: Tue, 23 Apr 2013 11:53:55 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>, wei_wang@realsil.com.cn
Subject: Re: linux-next: Tree for Apr 23 (usb storage)
References: <20130423180028.e08f92e6cc72105f67b77491@canb.auug.org.au>
In-Reply-To: <20130423180028.e08f92e6cc72105f67b77491@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/13 01:00, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130422:
> 


on i386, when CONFIG_PM_RUNTIME is not enabled so REALTEK_AUTOPM is not
enabled:

drivers/usb/storage/realtek_cr.c: In function 'realtek_cr_destructor':
drivers/usb/storage/realtek_cr.c:942:11: error: 'struct rts51x_chip' has no member named 'us'


-- 
~Randy
