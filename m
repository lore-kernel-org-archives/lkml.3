Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab3GPPkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:40:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:57702 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3GPPkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:40:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,677,1367996400"; 
   d="scan'208";a="346498435"
Message-ID: <1373989215.12825.25.camel@envy.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Darren Hart <dvhart@linux.intel.com>
To: Willy Tarreau <w@1wt.eu>
Cc: NeilBrown <neilb@suse.de>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Tue, 16 Jul 2013 08:40:15 -0700
In-Reply-To: <20130716061341.GD12242@1wt.eu>
References: <20130715155202.GC29526@xanatos>
	 <CA+55aFw-FSnVM1xpHs2HVooutz1ystAWYhsWLUqFiGU+owSTZw@mail.gmail.com>
	 <20130715174659.GC15531@xanatos>
	 <CA+55aFx4VoYZCEQ97jaAKDWViG1yfu9AikJ4R+dKru-qPVSY-A@mail.gmail.com>
	 <20130715180403.GD15531@xanatos>
	 <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com>
	 <20130715184642.GE15531@xanatos> <20130715191727.GC10157@1wt.eu>
	 <20130716084036.41a9c498@notabene.brown> <20130716061341.GD12242@1wt.eu>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-16 at 08:13 +0200, Willy Tarreau wrote:

> It can seem counter-producting first (as Sarah thinks) but I think that
> the competent people find their way in this simply because they're backed
> up by other ones. That's how I think we get that number of skilled people
> at the top of each subsystem.
> 

Hi Will,

I think you've made some excellent points and have done a good job
relating the mostly digital interactions to more direct and tangible
ones.

You have postulated (I believe) that because we have top-quality
maintainers (and I agree, we do), the process must be working. Perhaps
that was my interpretation and not your intent, but others have voiced
such opinions as well, so the following is still relevant.

What that argument fails to take into account are the top-quality
maintainers and contributors who are not present because of the
sometimes caustic environment of Linux kernel development: "survivor's
bias". There is a great article on the subject I read recently here:

http://youarenotsosmart.com/2013/05/23/survivorship-bias/


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

