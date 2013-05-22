Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab3EVWOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:14:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42184 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab3EVWOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:14:44 -0400
Date: Wed, 22 May 2013 15:14:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] Driver core / memory: Simplify
 __memory_block_change_state()
Message-ID: <20130522221443.GA7427@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
 <1824290.fKsAJTo9gA@vostro.rjw.lan>
 <519C4D6E.6080902@cn.fujitsu.com>
 <1594596.DcsjzgnrZI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594596.DcsjzgnrZI@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 12:06:50AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> As noted by Tang Chen, the last_online field in struct memory_block
> introduced by commit 4960e05 (Driver core: Introduce offline/online
> callbacks for memory blocks) is not really necessary, because
> online_pages() restores the previous state if passed ONLINE_KEEP as
> the last argument.  Therefore, remove that field along with the code
> referring to it.
> 
> References: http://marc.info/?l=linux-kernel&m=136919777305599&w=2
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
