Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3DLPjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:39:06 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65228 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab3DLPjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:39:04 -0400
Date: Fri, 12 Apr 2013 08:39:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>, Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2] Introduce Intel RAPL cooling device driver
Message-ID: <20130412153900.GB25603@kroah.com>
References: <1365195724-8945-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1365195724-8945-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <1365197195.2075.23.camel@joe-AO722>
 <20130405213518.GA5615@kroah.com>
 <20130412083203.13cf56b0@chromoly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412083203.13cf56b0@chromoly>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 08:32:03AM -0700, Jacob Pan wrote:
> If so, the reason being I don't know if there is a standard way
> to a transaction via sysfs where I can commit multiple inputs
> atomically.

That is by design.
