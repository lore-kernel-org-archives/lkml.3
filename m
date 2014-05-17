Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaEQChY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 22:37:24 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41930 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaEQChX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 22:37:23 -0400
Date: Sat, 17 May 2014 04:37:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/8] list: Out of line INIT_LIST_HEAD and list_del
Message-ID: <20140517023720.GI1873@two.firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
 <1400276595-6965-4-git-send-email-andi@firstfloor.org>
 <20140517000311.GA26496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517000311.GA26496@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Did you test this with CONFIG_DEBUG_LIST ?
> Unless I'm missing something, this looks like we'll have duplicate
> symbols for list_del if that is set.

Good point. Will fix.

BTW I only ran it in my limited config. I'm sure running it on 
different configs will show up other low hanging fruit ...

-Andi
