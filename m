Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3GQD7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 23:59:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:50396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab3GQD7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 23:59:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,682,1367996400"; 
   d="scan'208";a="366409710"
Message-ID: <51E616B2.2040805@linux.intel.com>
Date: Tue, 16 Jul 2013 20:59:46 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz> <51DF1B3C.8040603@linux.intel.com> <20130711210452.GE8900@pd.tnic> <51DF2566.8000806@linux.intel.com> <20130712075738.GB24008@pd.tnic>
In-Reply-To: <20130712075738.GB24008@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 12:57 AM, Borislav Petkov wrote:
> 
> Right, above sequence would work on AMD.
> 

Awesome.

	-hpa

