Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3IDVlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 17:41:36 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:15760 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761317Ab3IDVlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 17:41:35 -0400
Message-ID: <1378330785.10300.982.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 4/4] acpi: Return -ENOENT in acpi_table_parse() and
 fix wrong comment.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org, joe@perches.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Wed, 04 Sep 2013 15:39:45 -0600
In-Reply-To: <1378197941-26479-5-git-send-email-tangchen@cn.fujitsu.com>
References: <1378197941-26479-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1378197941-26479-5-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 16:45 +0800, Tang Chen wrote:
> The comment about return value of acpi_table_parse() is incorrect.
> This patch fix it.
> 
> Since all callers only check if the function succeeded or not, this
> patch simplifies the semantics by returning -errno for all failure
> cases. This will also simply the comment.
> 
> As suggested by Toshi Kani <toshi.kani@hp.com>, also change the stub
> in linux/acpi.h to return -ENODEV.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

