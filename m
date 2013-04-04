Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763024Ab3DDSu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:50:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:57754 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762864Ab3DDSu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:50:28 -0400
Message-ID: <515DCB78.3010207@infradead.org>
Date: Thu, 04 Apr 2013 11:50:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 4 (usb/gadget/configfs)
References: <20130404182232.bd2dbfba27620bdab9e0de42@canb.auug.org.au>
In-Reply-To: <20130404182232.bd2dbfba27620bdab9e0de42@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/13 00:22, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130403:
> 


on x86_64, when CONFIG_BUG is not enabled:

  CC [M]  drivers/usb/gadget/configfs.o
drivers/usb/gadget/configfs.c: In function 'config_usb_cfg_unlink':
drivers/usb/gadget/configfs.c:442:2: error: implicit declaration of function '__WARN_printf' [-Werror=implicit-function-declaration]
drivers/usb/gadget/configfs.c: In function 'configfs_do_nothing':
drivers/usb/gadget/configfs.c:733:2: error: implicit declaration of function '__WARN' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[4]: *** [drivers/usb/gadget/configfs.o] Error 1




-- 
~Randy
