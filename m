Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaKCKic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:38:32 -0500
Received: from zimbra.alphalink.fr ([217.15.80.77]:41835 "EHLO
	mail-2-cbv2.admin.alphalink.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751050AbaKCKia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:38:30 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Nov 2014 05:38:29 EST
Date: Mon, 3 Nov 2014 11:32:41 +0100
From: Guillaume Nault <g.nault@alphalink.fr>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, Phil Jensen <pjensen@evernote.com>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/102] 3.2.64-rc1 review
Message-ID: <20141103103241.GA5511@alphalink.fr>
References: <lsq.1414880882.522510247@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:28:02PM +0000, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.2.64 release.
> There are 102 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
You might want to add eed4d839 "l2tp: fix race while getting PMTU on
PPP pseudo-wire". It fixes f34c4a35 ("l2tp: take PMTU from tunnel UDP
socket") which reached linux-3.2.y under commit 109d10d1.

The 3.16.y, 3.14.y, 3.12.y and 3.10.y trees already applied the fix.
Other stable/longterm trees which backported f34c4a35, like
linux-3.4.y, should condider applying this fix too.

Regards,

Guillaume
