Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3LMErU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 23:47:20 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53411 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751825Ab3LMErT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 23:47:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH] Driver core: Fix device_add_attrs() error code path
Date: Fri, 13 Dec 2013 06:00:29 +0100
Message-ID: <1467967.plPSuQXO6g@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131212231333.GC7763@kroah.com>
References: <1902491.UTh5DYb76O@vostro.rjw.lan> <20131212231333.GC7763@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 12, 2013 03:13:33 PM Greg Kroah-Hartman wrote:
> On Thu, Dec 12, 2013 at 06:11:02AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > If the addition of dev_attr_online fails, device_add_attrs() should
> > remove device attribute groups as well as type and class attribute
> > groups before returning an error code.  Make that happen.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Does this need tob e in 3.13-final?  Or can it wait for 3.14-rc1?  The
> odds that this file creation would ever fail is _really_ low, right?

Yeah, it's more of a cleanup than a fix, so 3.14-rc1 should be fine.

Thanks,
Rafael

