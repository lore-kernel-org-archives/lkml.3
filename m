Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaATIj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:39:58 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:43981 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbaATIj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:39:56 -0500
Date: Mon, 20 Jan 2014 09:39:48 +0100
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
To: "Strashko, Grygorii" <grygorii.strashko@ti.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "qiuxishi@huawei.com" <qiuxishi@huawei.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "daeseok.youn@gmail.com" <daeseok.youn@gmail.com>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "zhangyanfei@cn.fujitsu.com" <zhangyanfei@cn.fujitsu.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "tangchen@cn.fujitsu.com" <tangchen@cn.fujitsu.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3 2/2] mm/memblock: Add support for excluded memory
 areas
Message-ID: <20140120093948.0add11f4@lilie>
In-Reply-To: <902E09E6452B0E43903E4F2D568737AB0B9852BA@DFRE01.ent.ti.com>
References: <1389618217-48166-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1389618217-48166-3-git-send-email-phacht@linux.vnet.ibm.com>
	<52D538FD.8010907@ti.com>
	<20140114195225.078f810a@lilie>
	<902E09E6452B0E43903E4F2D568737AB0B9852BA@DFRE01.ent.ti.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012008-2966-0000-0000-000009FBA9A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Fri, 17 Jan 2014 18:08:13 +0000
schrieb "Strashko, Grygorii" <grygorii.strashko@ti.com>:

Hello Grygorii,

> > The current patch seems to be overly complicated.
> > The following patch contains only the nomap functionality without
> > any cleanup and refactoring. I will post a V4 patch set which will
> > contain this patch.

please see the V4 patch set I've sent to the list. There you will
clearly see that nothing is changed. No API is broken by the patch.
The patch only adds functionality.
Everything that worked before keeps working as before without any
changes needed in any arch's code.

Kind regards

Philipp

