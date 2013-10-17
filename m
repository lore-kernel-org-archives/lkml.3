Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3JQLbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:31:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:45687 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321Ab3JQLbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:31:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,513,1378882800"; 
   d="scan'208";a="418313628"
Date: Thu, 17 Oct 2013 14:30:27 +0300
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
Message-ID: <20131017112806.GA5293@intel.com>
References: <20130920203556.GA8726@www.outflux.net>
 <alpine.LRH.2.02.1310171858170.32257@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1310171858170.32257@tundra.namei.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 07:02:17PM +1100, James Morris wrote:
> This seems like a regression in terms of separating mechanism and policy.  
> 
> We have several access control systems available (SELinux, at least) which 
> can implement this functionality with existing mechanisms using dynamic 
> policy.
> 
> I'm concerned about the long term architectural impact of a proliferation 
> of arbitrary hard-coded security policies in the kernel.  I don't 
> understand the push in this direction, frankly.

The biggest risk in LSM stacker is really to become backdoor for very product
dilated kernel changes that are not accepted to the mainline kernel. I think
having LSM stacker would be benefical but barrier should be set very high
for "one-shot" modules.

One big benefit that I see in LSM stacker is not at least directly security
related. It would be perfect integration tool when you want for example
provide Android run-time in an OS that uses AppArmor or SMACK as its security
framework.

/Jarkko
