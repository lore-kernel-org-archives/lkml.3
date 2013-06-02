Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab3FBL4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 07:56:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab3FBL4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 07:56:16 -0400
Date: Sun, 2 Jun 2013 13:56:34 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] irqdomain: Do not reuse existing mappings
Message-ID: <20130602115634.GA15561@dhcp-26-207.brq.redhat.com>
References: <20130531125910.GA1454@dhcp-26-207.brq.redhat.com>
 <20130531223024.AB12F3E08FE@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531223024.AB12F3E08FE@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 11:30:24PM +0100, Grant Likely wrote:
> On Fri, 31 May 2013 14:59:11 +0200, Alexander Gordeev <agordeev@redhat.com> wrote:
> What exactly is the problem that you're trying to solve with this patch?
> It's not clear from the description.

Hi Grant,

Thanks for the clarification!

No particular problem - I just was confused with this particular behaviour
and failed to put RFC in subject line. Sorry for that.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
