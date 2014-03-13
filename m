Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaCMPyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:54:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39183 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbaCMPym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:54:42 -0400
Message-ID: <5321D49E.30705@zytor.com>
Date: Thu, 13 Mar 2014 08:54:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        James Morris <jmorris@namei.org>
CC: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>	<1394686919.25122.2.camel@x230>	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org> <20140313101235.753c3ec0@alan.etchedpixels.co.uk>
In-Reply-To: <20140313101235.753c3ec0@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 03:12 AM, One Thousand Gnomes wrote:
> 
> I would prefer it did the revocation of CAP_SYS_RAWIO or at least
> documented the absolute requirement.
> 

Seconded.  This has been my opinion, raised over and over and over again.

	-hpa


