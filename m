Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab3GKUxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:53:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:33465 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab3GKUxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:53:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,647,1367996400"; 
   d="scan'208";a="363907696"
Message-ID: <51DF1B3C.8040603@linux.intel.com>
Date: Thu, 11 Jul 2013 13:53:16 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 01:26 PM, Jiri Kosina wrote:
> 
> synchronization after replacing "all but first" instructions should not
> be necessary (on Intel hardware), as the syncing after the subsequent
> patching of the first byte provides enough safety.
> But there's not only Intel HW out there, and we'd rather be on a safe
> side.
> 

Has anyone talked to AMD or VIA about this at all?  Did anyone else ever
make SMP-capable x86?

	-hpa

