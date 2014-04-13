Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaDMWDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 18:03:37 -0400
Received: from one.firstfloor.org ([193.170.194.197]:50091 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaDMWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 18:03:36 -0400
Date: Mon, 14 Apr 2014 00:03:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ling Ma <ling.ma.program@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, neleai@seznam.cz, linux-kernel@vger.kernel.org,
        Ling Ma <ling.ml@alibaba-inc.com>
Subject: Re: [PATCH RFC] x86:Improve memset with general 64bit instruction
Message-ID: <20140413220334.GE22728@two.firstfloor.org>
References: <1396882237-27608-1-git-send-email-ling.ma@alipay.com>
 <877g71jdl8.fsf@tassilo.jf.intel.com>
 <CAOGi=dPOEnNOLfnxTfvsVupRWQZtGs7-9LxDF8g2Kbun2v0hQA@mail.gmail.com>
 <CAOGi=dMbRv6S+UGthYTCvW=C7hBRwpnZdM-BYYqT1fn=kF2SLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOGi=dMbRv6S+UGthYTCvW=C7hBRwpnZdM-BYYqT1fn=kF2SLg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 11:11:59PM +0800, Ling Ma wrote:
> Any further comments  ?

It would be good to test on some more machines that you don't cause
regressions.

But I'm not aware of any workload that is doing a lot of memset (not
counting clear_page).  Copies likely matter much more.

-Andi
