Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3ESBXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 21:23:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3ESBXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 21:23:31 -0400
Date: Sat, 18 May 2013 18:23:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <liuj97@gmail.com>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/5] Driver core / MM: Drop offline_memory_block()
Message-ID: <20130519012347.GA26947@kroah.com>
References: <2250271.rGYN6WlBxf@vostro.rjw.lan>
 <2529630.QGJsLhExPp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2529630.QGJsLhExPp@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 01:33:02AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Since offline_memory_block(mem) is functionally equivalent to
> device_offline(&mem->dev), make the only caller of the former use
> the latter instead and drop offline_memory_block() entirely.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
