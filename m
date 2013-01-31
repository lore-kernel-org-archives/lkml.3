Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3AaFW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:22:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:50496 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab3AaFWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:22:52 -0500
Date: Thu, 31 Jan 2013 06:24:48 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, guohanjun@huawei.com,
        yinghai@kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [RFC PATCH v2 01/12] Add sys_hotplug.h for system device hotplug
 framework
Message-ID: <20130131052448.GC3228@kroah.com>
References: <1357861230-29549-1-git-send-email-toshi.kani@hp.com>
 <5036592.TuXAnGzk4M@vostro.rjw.lan>
 <1358177628.14145.49.camel@misato.fc.hp.com>
 <2154272.qDAyBlTr8z@vostro.rjw.lan>
 <1358190124.14145.79.camel@misato.fc.hp.com>
 <20130130044859.GD30002@kroah.com>
 <1359594912.15120.85.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359594912.15120.85.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 06:15:12PM -0700, Toshi Kani wrote:
> > Please make it a "real" pointer, and not a void *, those shouldn't be
> > used at all if possible.
> 
> How about changing the "void *handle" to acpi_dev_node below?   
> 
>    struct acpi_dev_node    acpi_node;
> 
> Basically, it has the same challenge as struct device, which uses
> acpi_dev_node as well.  We can add other FW node when needed (just like
> device also has *of_node).

That sounds good to me.

