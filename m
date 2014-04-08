Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbaDHN56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:57:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52533 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756385AbaDHN55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:57:57 -0400
Date: Tue, 8 Apr 2014 10:57:30 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Kees Cook <keescook@chromium.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: avoid workqueue format string leak
Message-ID: <20140408135729.GC2429@arch.cereza>
References: <20140408044407.GA13141@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140408044407.GA13141@www.outflux.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kees,

Thanks for the patch.

On Apr 07, Kees Cook wrote:
> When building the name for the workqueue thread, make sure a format
> string cannot leak in from the disk name.
> 

Could you enlighten me and explain why you want to avoid the name leak?
Is it a security concern?

I'd like to understad this better, so I can avoid making such mistakes
in the future.

Thanks,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
