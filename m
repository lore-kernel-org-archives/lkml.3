Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3GRINp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:13:45 -0400
Received: from purkki.adurom.net ([80.68.90.206]:34413 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063Ab3GRINm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:13:42 -0400
X-Greylist: delayed 1668 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jul 2013 04:13:41 EDT
From: Kalle Valo <kvalo@adurom.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable kernel, let's dump the cc: stable tag
References: <1373916476.2748.69.camel@dabdike>
	<20130715214422.GA2478@kroah.com> <1373951852.2148.9.camel@dabdike>
	<20130716062058.GB19052@kroah.com> <1373960616.2148.34.camel@dabdike>
	<20130717150857.GA2291@tuxdriver.com>
Date: Thu, 18 Jul 2013 10:45:47 +0300
In-Reply-To: <20130717150857.GA2291@tuxdriver.com> (John W. Linville's message
	of "Wed, 17 Jul 2013 11:08:58 -0400")
Message-ID: <87k3koxqdw.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"John W. Linville" <linville@tuxdriver.com> writes:

> Is having a flood of fixes in x.y.1 any worse than having to got to an
> -rc8 or an -rc9?

I think it's better to send less fixes to -rc8 or -rc9 and focus more on
testing. That way there should be less regressions in later stages of
-rc releases and especially in the final x.y.0 release.

Most of the time I don't even consider updating to the stable releases,
I just wait for the next .0 release from Linus. For this kind of
workflow there is a clear advantage of slowing down patch flow before
the release, better chances of not needing to update the kernel that
often.

-- 
Kalle Valo
