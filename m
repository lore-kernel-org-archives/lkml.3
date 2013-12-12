Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3LLXLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:11:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3LLXLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:11:49 -0500
Date: Thu, 12 Dec 2013 15:13:33 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH] Driver core: Fix device_add_attrs() error code path
Message-ID: <20131212231333.GC7763@kroah.com>
References: <1902491.UTh5DYb76O@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1902491.UTh5DYb76O@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 06:11:02AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> If the addition of dev_attr_online fails, device_add_attrs() should
> remove device attribute groups as well as type and class attribute
> groups before returning an error code.  Make that happen.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Does this need tob e in 3.13-final?  Or can it wait for 3.14-rc1?  The
odds that this file creation would ever fail is _really_ low, right?

thanks,

greg k-h
