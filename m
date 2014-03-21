Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbaCUNVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:21:24 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58676 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaCUNVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:21:22 -0400
Date: Fri, 21 Mar 2014 14:21:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Joe Perches <joe@perches.com>
Cc: Jean Delvare <jdelvare@suse.de>, Andi Kleen <andi@firstfloor.org>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch on Kconfig files
Message-ID: <20140321132121.GL22728@two.firstfloor.org>
References: <20140321094239.18aebf02@endymion.delvare>
 <1395392257.7776.74.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395392257.7776.74.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe that was Andi Kleen's pet peeve,
> so I'll punt it back to him.

This was always in checkpatch. If you touch/move some existing
code it blames you for the issues that were already there.

Not specific to this check.

If you disagree with the warnings just ignore them.

-Andi
