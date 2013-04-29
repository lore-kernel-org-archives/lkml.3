Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3D2QSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:18:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:56596 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab3D2QSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:18:03 -0400
Message-ID: <517E9D20.7080403@infradead.org>
Date: Mon, 29 Apr 2013 09:17:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 29 (include/linux/proc_fs.h: proc_net_mkdir)
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
In-Reply-To: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/13 02:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130426:
> 

when CONFIG_PROC_FS is not enabled:

  CC      init/main.o
In file included from init/main.c:16:0:
include/linux/proc_fs.h: In function 'proc_net_mkdir':
include/linux/proc_fs.h:69:2: error: implicit declaration of function 'proc_mkdir_data' [-Werror=implicit-function-declaration]
include/linux/proc_fs.h:69:2: warning: return makes pointer from integer without a cast [enabled by default]




-- 
~Randy
