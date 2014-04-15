Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180AbaDOFBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 01:01:31 -0400
Received: from one.firstfloor.org ([193.170.194.197]:55417 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaDOFBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 01:01:30 -0400
Date: Tue, 15 Apr 2014 07:01:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ling Ma <ling.ma.program@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, neleai@seznam.cz, linux-kernel@vger.kernel.org,
        Ling Ma <ling.ml@alibaba-inc.com>
Subject: Re: [PATCH RFC] x86:Improve memset with general 64bit instruction
Message-ID: <20140415050128.GH22728@two.firstfloor.org>
References: <1396882237-27608-1-git-send-email-ling.ma@alipay.com>
 <877g71jdl8.fsf@tassilo.jf.intel.com>
 <CAOGi=dPOEnNOLfnxTfvsVupRWQZtGs7-9LxDF8g2Kbun2v0hQA@mail.gmail.com>
 <CAOGi=dMbRv6S+UGthYTCvW=C7hBRwpnZdM-BYYqT1fn=kF2SLg@mail.gmail.com>
 <20140413220334.GE22728@two.firstfloor.org>
 <CAOGi=dOoCkU5Ni8r7pyejMuSdkMt2jOPs2J2OEQ9YxABxNYibw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOGi=dOoCkU5Ni8r7pyejMuSdkMt2jOPs2J2OEQ9YxABxNYibw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:31:16PM +0800, Ling Ma wrote:
> The kernel version 3.14 shows memcpy, memset occur 19622 and  14189
> times respectively.
> so memset is still important for us, correct?

Did you ever see it in a profile log as being hot?
I haven't. Static counts don't mean much.

-Andi
