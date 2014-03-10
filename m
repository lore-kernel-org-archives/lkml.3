Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaCJAAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 20:00:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:11613 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbaCJAAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 20:00:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,620,1389772800"; 
   d="scan'208";a="469301533"
Message-ID: <531D009F.1060803@linux.intel.com>
Date: Sun, 09 Mar 2014 17:00:31 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stefani Seibold <stefani@seibold.net>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [x86, vdso]  BUG: unable to handle kernel paging request at d34bd000
References: <20140307013833.GD8427@localhost>	 <1394182034.21684.6.camel@wall-e.seibold.net>	 <20140307091515.GA8888@localhost>	 <1394186248.28066.42.camel@wall-e.seibold.net>	 <20140307234411.GA14886@localhost> <1394352497.1002.4.camel@wall-e.seibold.net>
In-Reply-To: <1394352497.1002.4.camel@wall-e.seibold.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2014 12:08 AM, Stefani Seibold wrote:
> 
> This was not addressed to you, it was addressed to the x86 intel kernel
> developers to do more testing, since this piece of code has so many side
> effects. I apologizes this miss understanding.
> 

I think you're misunderstanding.

We cannot debug every single contributors' code for them.  There isn't
enough of us to go around.  We have in fact stretched well beyond the
point which we usually can accommodate for this particular patchset.

	-hpa


