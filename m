Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaCaOuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:50:02 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54387 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaCaOt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:49:59 -0400
Date: Mon, 31 Mar 2014 16:49:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Shuduo Sang <shuduo.sang@canonical.com>
Cc: ibm-acpi@hmh.eng.br, matthew.garrett@nebula.com,
        ibm-acpi-devel@lists.sourceforge.net,
        platofor-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        bruce.ma@canonical.com
Subject: Re: [PATCH V4 RESEND] Support Thinkpad X1 Carbon 2nd gen's adaptive
 keyboard
Message-ID: <20140331144956.GC21805@xo-6d-61-c0.localdomain>
References: <531EECF9.1040600@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531EECF9.1040600@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Resend patch V4. Support Thinkpad X1 Carbon 2nd generation's adaptive
> keyboard.
> 
> Hi Henrique, could you please have a chance to review it?

As far as I can tell... thinkpad just has small display above its function keys (right?).

Would it be possible to support it as a display? (/dev/fb1)?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
