Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaJ1M4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:56:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:21308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbaJ1M4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:56:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,802,1406617200"; 
   d="scan'208";a="597621985"
Date: Tue, 28 Oct 2014 05:56:30 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com,
        linux-doc@vger.kernel.org, kexec@lists.infradead.org,
        linux-api@vger.kernel.org, jason.wessel@windriver.com
Subject: Re: [PATCH V4] kernel, add bug_on_warn
Message-ID: <20141028125630.GF3274@tassilo.jf.intel.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com>
 <20141028121636.GC3274@tassilo.jf.intel.com>
 <544F8A78.9070008@redhat.com>
 <20141028122900.GA10632@redhat.com>
 <20141028124425.GD3274@tassilo.jf.intel.com>
 <544F90B1.1070102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544F90B1.1070102@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If you have a command line option to execute kdb commands you still
> > would only have a command line option, just a slightly longer one.
> > 
> > kdb="on, bp warn_slowpath_common sr c, go" 
> 
> KDB is not on all kernels.  This would require me to go to great lengths to

Repeating incorrect statements doesn't suddenly make them correct.

Assuming KDB is compiled in the only setup needed would be the line above.

-Andi

