Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3BDVm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:42:59 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:43133 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3BDVm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:42:57 -0500
Date: Mon, 4 Feb 2013 13:42:51 -0800
From: Tejun Heo <tj@kernel.org>
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "skinsbursky@parallels.com" <skinsbursky@parallels.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130204214251.GH27963@mtj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130204191720.GW27963@mtj.dyndns.org>
 <32E1700B9017364D9B60AED9960492BC0D58DF5C@FMSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D58DF5C@FMSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 07:54:12PM +0000, Marciniszyn, Mike wrote:
> It looks like this kernel won't compile with CONFIG_HOTPLUG_MEMORY set to 'y'

Hmm... it build fine here.  Can you please attach the .config?

Thanks.

-- 
tejun
