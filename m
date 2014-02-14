Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaBNQ0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:26:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55021 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaBNQ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:26:14 -0500
Message-ID: <52FE4397.6030301@zytor.com>
Date: Fri, 14 Feb 2014 08:25:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 14/17] Kbuild, lto: Add Link Time Optimization support
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com> <1391846481-31491-14-git-send-email-ak@linux.intel.com> <52FD9B5A.4020905@zytor.com> <20140214143649.GQ12219@tassilo.jf.intel.com>
In-Reply-To: <20140214143649.GQ12219@tassilo.jf.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 06:36 AM, Andi Kleen wrote:
> On Thu, Feb 13, 2014 at 08:28:10PM -0800, H. Peter Anvin wrote:
>> I am about to commit the patches before this except 02/17 and 12/17 to
>> tip:x86/asmlinkage; however, I figure we need a new 02/17 before
>> committing the actual LTO patches to avoid build breakage.
> 
> Thanks.
> 
> Yes I'll repost today.
> 
> I was assuming those would go through the kbuild tree.
> 

I'll check with Michal to see if he cares.

	-hpa


