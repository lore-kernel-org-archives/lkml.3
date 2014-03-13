Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaCMV1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:27:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35571 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaCMV1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:27:06 -0400
Date: Thu, 13 Mar 2014 21:26:47 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140313212647.7412aadf@alan.etchedpixels.co.uk>
In-Reply-To: <1394726363.25122.16.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
	<1394726363.25122.16.camel@x230>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On the other hand, disabling CAP_SYS_RAWIO *definitely* breaks expected
> functionality - firmware loading and the fibmap ioctl are probably the
> most obvious. And changing the use of CAP_SYS_RAWIO potentially breaks
> userspace expectations, so we're kind of stuck there.

Actually I know how to describe the problem better.

Whitelist v Blacklist.

Going around adding extra cases for CAP_SYS_RAWIO is a fails insecure
model. Going around adding CAP_SYS_RAWIO || CAP_SYS_RAWIO_SEC is a 'fails
secure' case.

Alan
