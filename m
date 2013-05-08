Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3EHOiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:38:17 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:35614 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab3EHOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:38:15 -0400
Message-ID: <1368023891.30363.40.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/2 v2, RFC] Driver core: Introduce offline/online
 callbacks for memory blocks
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        Len Brown <lenb@kernel.org>, linux-mm@kvack.org, wency@cn.fujitsu.com
Date: Wed, 08 May 2013 08:38:11 -0600
In-Reply-To: <4229865.4cv6g5bbx4@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
	 <1738385.YBsAESXG5F@vostro.rjw.lan>
	 <1367973454.30363.38.camel@misato.fc.hp.com>
	 <4229865.4cv6g5bbx4@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-08 at 13:53 +0200, Rafael J. Wysocki wrote:
> On Tuesday, May 07, 2013 06:37:34 PM Toshi Kani wrote:
> > On Wed, 2013-05-08 at 02:24 +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, May 07, 2013 05:59:16 PM Toshi Kani wrote:

 :
 
> > > Moreover, it'd be better to do it in register_memory(), I think.
> > 
> > Yes, if we change register_memory() to have the arg state.
> 
> It can use mem->state which already has been populated at this point
> (and init_memory_block() is the only called).

Right.

> I've updated the patch to do that (appended).

Looks good!  Thanks for the update!
-Toshi




