Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab3EVXUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 19:20:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46409 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab3EVXUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 19:20:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] Driver core / memory: Simplify __memory_block_change_state()
Date: Thu, 23 May 2013 01:29:36 +0200
Message-ID: <2523424.su5lDNaCQ2@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130522221443.GA7427@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <1594596.DcsjzgnrZI@vostro.rjw.lan> <20130522221443.GA7427@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 22, 2013 03:14:43 PM Greg Kroah-Hartman wrote:
> On Thu, May 23, 2013 at 12:06:50AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > As noted by Tang Chen, the last_online field in struct memory_block
> > introduced by commit 4960e05 (Driver core: Introduce offline/online
> > callbacks for memory blocks) is not really necessary, because
> > online_pages() restores the previous state if passed ONLINE_KEEP as
> > the last argument.  Therefore, remove that field along with the code
> > referring to it.
> > 
> > References: http://marc.info/?l=linux-kernel&m=136919777305599&w=2
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks!

