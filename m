Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964835Ab3FSWGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:06:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:4755 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935082Ab3FSWGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:06:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,900,1363158000"; 
   d="scan'208";a="332383585"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Joe Perches <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net] checkpatch: modify logFunction regular expression to
 allow repeated front tags
Thread-Topic: [net] checkpatch: modify logFunction regular expression to
 allow repeated front tags
Thread-Index: AQHObNk8jD3IbFnhZEOX5zH10GlEU5k9gTWAgAAXdoA=
Date: Wed, 19 Jun 2013 22:06:26 +0000
Message-ID: <02874ECE860811409154E81DA85FBB585650A046@ORSMSX104.amr.corp.intel.com>
References: <1371638323-20999-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1371649323.2038.23.camel@joe-AO722>
In-Reply-To: <1371649323.2038.23.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Wednesday, June 19, 2013 6:42 AM
> To: Kirsher, Jeffrey T
> Cc: apw@canonical.com; Keller, Jacob E; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [net] checkpatch: modify logFunction regular expression to
> allow repeated front tags
> 
> On Wed, 2013-06-19 at 03:38 -0700, Jeff Kirsher wrote:
> > From: Jacob Keller <jacob.e.keller@intel.com>
> >
> > The previous logFunction regular expression allowed names for log
> functions like
> > dev_warn or e_dbg and so forth, but some log functions are of the
> forms
> > similar to e_dev_warn, (adding an additional tag in front of a standard
> name
> > like dev_warn).
> 
> Perhaps names like foo_bar_baz_dev_warn are a bit long.
> 
> Maybe instead of
> +	(?:[a-z0-
> 9]+_)+(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug
> |dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
> use
> +	(?:[a-z0-
> 9]+_){0,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|de
> bug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
> 

That sounds good to me.

- Jake

