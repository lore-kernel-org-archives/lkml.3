Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaGQJy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:54:27 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:60165 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbaGQJyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:54:25 -0400
Message-ID: <1405590862.4808.22.camel@x220>
Subject: Re: direct-io: squelch maybe-uninitialized warning in do_direct_IO()
From: Paul Bolle <pebolle@tiscali.nl>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk,
        Borislav Petkov <bp@alien8.de>, Sam Ravnborg <sam@ravnborg.org>,
        pramod.gurav.etc@gmail.com, Jason Cooper <jason@lakedaemon.net>,
        Markus Mayer <markus.mayer@linaro.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Jul 2014 11:54:22 +0200
In-Reply-To: <53C79A1C.5060402@gmail.com>
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
		 <20140713115022.GA6054@infradead.org> <53C6B199.2070606@gmail.com>
		 <20140716175803.GA3631@infradead.org> <1405536124.4357.17.camel@x41>
	 <53C79949.7010201@gmail.com> <53C79A1C.5060402@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2014 09:54:23.0343 (UTC) FILETIME=[1655C7F0:01CFA1A5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz,

On Thu, 2014-07-17 at 12:40 +0300, Boaz Harrosh wrote:
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Paul this is your patch I put you as Signed-off-by please acknowledge

I never signed off on that patch! Speaking from memory, I just sent a
message stating that "something like this" might silence the warning. I
also stated that I needed to have another look at it.

This touches code I did not write and do not yet understand well enough.
Getting there requires a clean schedule, clean head, and/or a clean
desk. I certainly won't sign off on it until one or more of those
conditions are met.

Please don't do this (adding a Signed-off-by on a patch I drafted)
again!


Paul Bolle

