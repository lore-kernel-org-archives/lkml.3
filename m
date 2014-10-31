Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaJaIJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:09:55 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaJaIJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:09:53 -0400
Message-ID: <545343CA.7080507@nod.at>
Date: Fri, 31 Oct 2014 09:09:46 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: hujianyang <hujianyang@huawei.com>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: vtbl: Use ubi_eba_atomic_leb_change()
References: <1414259021-5691-1-git-send-email-richard@nod.at> <1414659349.23185.27.camel@sauron.fi.intel.com> <54530A29.9070208@huawei.com>
In-Reply-To: <54530A29.9070208@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hujianyang,

Am 31.10.2014 um 05:03 schrieb hujianyang:
> Hi Artem and Richard,
> 
> We are using atomic operation, leb_change(), for master_node
> in ubifs-level. We use two lebs for master_node even if they
> are changed with atomic operation.
> 
> I think volume_table and master_node play similar roles. Do
> you think changing VTBL record into one peb is OK? I just
> what to know if I missed something. Could you please take
> some time to explain that?

I'm not sure if I correctly understand your question.

If we use only one PEB for the VTBL existing UBI implementations
would break as they assume we have two.

Thanks,
//richard
