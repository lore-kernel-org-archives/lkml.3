Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaCMV23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:28:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44320 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335AbaCMV21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:28:27 -0400
Message-ID: <532222E1.2020405@zytor.com>
Date: Thu, 13 Mar 2014 14:28:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>	<1394686919.25122.2.camel@x230>	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>	<1394726363.25122.16.camel@x230> <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
In-Reply-To: <20140313212450.67f1de8e@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 02:24 PM, One Thousand Gnomes wrote:
> 
> If I have CAP_SYS_RAWIO I can make arbitary ring 0 calls from userspace,
> trivially and in a fashion well known and documented.
> 

... and once we eliminate CAP_SYS_RAWIO a bunch of the patches become
redundant.

	-hpa

