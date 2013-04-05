Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162811Ab3DEV5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:57:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:53449 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162601Ab3DEV5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:57:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,417,1363158000"; 
   d="scan'208";a="290129370"
Date: Fri, 5 Apr 2013 14:57:20 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2] Introduce Intel RAPL cooling device driver
Message-ID: <20130405145720.74ec046f@chromoly>
In-Reply-To: <1365197195.2075.23.camel@joe-AO722>
References: <1365195724-8945-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1365195724-8945-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<1365197195.2075.23.camel@joe-AO722>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Apr 2013 14:26:35 -0700
Joe Perches <joe@perches.com> wrote:

> > +/* in the order of enum rapl_primitives */
> > +static struct rapl_primitive_info rpi[] = {  
> 
> const?
I do need to override one entry for a special case. The hardware uses a
different bit location for the same lock functionality.

The other comments are well taken,

-- 
Thanks,

Jacob
