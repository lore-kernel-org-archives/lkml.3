Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaCaPNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:13:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54885 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaCaPND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:13:03 -0400
Date: Mon, 31 Mar 2014 17:12:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Shuduo Sang <shuduo.sang@canonical.com>
Cc: ibm-acpi@hmh.eng.br, matthew.garrett@nebula.com,
        ibm-acpi-devel@lists.sourceforge.net,
        platofor-driver-x86@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bruce Ma <bruce.ma@canonical.com>
Subject: Re: [PATCH V4 RESEND] Support Thinkpad X1 Carbon 2nd gen's adaptive
 keyboard
Message-ID: <20140331151258.GA8380@xo-6d-61-c0.localdomain>
References: <531EECF9.1040600@canonical.com>
 <20140331144956.GC21805@xo-6d-61-c0.localdomain>
 <CA+BAWBSqF=tL9cRm2oDb3hRMxebFV69BrgzfTbcvaGjRfKnrMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+BAWBSqF=tL9cRm2oDb3hRMxebFV69BrgzfTbcvaGjRfKnrMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-03-31 23:00:36, Shuduo Sang wrote:
> On Mon, Mar 31, 2014 at 10:49 PM, Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Hi!
> >
> > > Resend patch V4. Support Thinkpad X1 Carbon 2nd generation's adaptive
> > > keyboard.
> > >
> > > Hi Henrique, could you please have a chance to review it?
> >
> > As far as I can tell... thinkpad just has small display above its function
> > keys (right?).
> >
> > Would it be possible to support it as a display? (/dev/fb1)?
> >
> 
> Not possible so far.

Can you elaborate?

Is the problem that hw only supports few fixed images for that display?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
