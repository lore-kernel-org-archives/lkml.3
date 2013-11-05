Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3KEWna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:43:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3KEWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:43:29 -0500
Date: Tue, 5 Nov 2013 14:43:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH 2/2]  mtd: cmdlinepart: use cmdline partition parser lib
Message-Id: <20131105144328.fb5a6a1d423776b324771706@linux-foundation.org>
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C084C81@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
	<20131020120603.GA18678@localhost>
	<C3050A4DBA34F345975765E43127F10F1C084C81@szxeml512-mbs.china.huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Oct 2013 13:14:17 +0000 Caizhiyong <caizhiyong@hisilicon.com> wrote:

> In the previous version, adjust the cmdline parser code to library-style
> code, and move it to a separate file "block/cmdline-parser.c", we can use
> it in some client code. there is no any functionality change in the adjusting.
> 
> this patch use cmdline parser lib.
> 
> For further information, see "https://lkml.org/lkml/2013/8/6/550"

Thanks for doing this.  Could we please get some acked-by's or,
preferably, tested-by's from the MTD people?

