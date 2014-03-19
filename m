Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbaCSL6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:58:01 -0400
Received: from smtp.citrix.com ([66.165.176.89]:14047 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933380AbaCSL6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:58:00 -0400
X-IronPort-AV: E=Sophos;i="4.97,685,1389744000"; 
   d="scan'208";a="112817865"
Message-ID: <53298646.4080404@citrix.com>
Date: Wed, 19 Mar 2014 11:57:58 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, <lkp@01.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [mm/vmalloc] BUG: sleeping function called from invalid context
 at mm/vmalloc.c:74
References: <20140319115540.GA7277@localhost>
In-Reply-To: <20140319115540.GA7277@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/14 11:55, Fengguang Wu wrote:
> Hi David,
> 
> FYI, we noticed the below BUG on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 032dda8b6c4021d4be63bcc483b47fd26c6f48a2 ("mm/vmalloc: avoid soft lockup warnings when vunmap()'ing large ranges")

Thanks,  this patches have been are in the process of being dropped.

David
