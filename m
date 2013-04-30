Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab3D3QjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:39:07 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46627 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab3D3QjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:39:04 -0400
Date: Tue, 30 Apr 2013 09:39:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH -next] tty.h: fix build errors when PROC_FS is not
 enabled
In-Reply-To: <517E9A4F.1080609@infradead.org>
Message-ID: <alpine.DEB.2.02.1304300938520.31619@chino.kir.corp.google.com>
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au> <517E9A4F.1080609@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Randy Dunlap wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build error when CONFIG_PROC_FS is not enabled:
> 
> include/linux/tty.h: In function 'proc_tty_register_driver':
> include/linux/tty.h:698:52: error: parameter name omitted
> include/linux/tty.h: In function 'proc_tty_unregister_driver':
> include/linux/tty.h:699:54: error: parameter name omitted
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Acked-by: David Rientjes <rientjes@google.com>
