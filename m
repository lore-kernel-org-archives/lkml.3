Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308Ab3DCUNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:13:23 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43012 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762404Ab3DCUNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:13:22 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <1364984183-9711-2-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1364984183-9711-1-git-send-email-liwanp@linux.vnet.ibm.com> <1364984183-9711-2-git-send-email-liwanp@linux.vnet.ibm.com>
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Date: Wed, 3 Apr 2013 16:13:01 -0400
X-Google-Sender-Auth: DtKN4S0le0nhlRQ3JDV2SBPaNoM
Message-ID: <CAPbh3ru54LVA1gVqH7seXWgAviz-dbiFKfXC3RVHZqUbk9=y0Q@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] staging: zcache: fix static variables defined in
 debug.h but used in mutiple C files
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 6:16 AM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
> After commit 95bdaee214 ("zcache: Move debugfs code out of zcache-main.c file")
> be merged, most of knods in zcache debugfs just export zero since these variables
> are defined in debug.h but are in use in multiple C files zcache-main.c and debug.c,
> in this case variables can't be treated as shared variables.
>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
