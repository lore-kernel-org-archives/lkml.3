Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbaJVVno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:43:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58512 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbaJVVnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:43:42 -0400
Message-ID: <544824F3.9000808@zytor.com>
Date: Wed, 22 Oct 2014 14:43:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Paulo Zanoni <przanoni@gmail.com>, Richard Guy Briggs <rgb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: Regression: audit: x86: drop arch from __audit_syscall_entry()
 interface
References: <CA+gsUGSiXf2gpB8QQOQOmgxFc8mx31V6qeRqow6aXO1195jWEA@mail.gmail.com>	 <1414002190.30946.95.camel@localhost>	 <alpine.DEB.2.11.1410222323500.5308@nanos> <1414013897.30946.102.camel@localhost>
In-Reply-To: <1414013897.30946.102.camel@localhost>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 02:38 PM, Eric Paris wrote:
> 
> It was sent, numerous times, to the x86 list for reviews, and lived in
> -next for 2 complete devel cycles without a complaint.  I'm trying to
> get an i386 system to test a fix.  But yes, it's total crap.
> 

You don't need an i386 system -- you can install an i386 distro on an
x86-64 system, or in KVM.

	-hpa


