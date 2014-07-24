Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbaGXHGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:06:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:57671 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbaGXHGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:06:49 -0400
Message-ID: <53D0B07B.5040600@ahsoftware.de>
Date: Thu, 24 Jul 2014 09:06:35 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>, Tejun Heo <tj@kernel.org>
CC: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: general protection fault on 3.15.6
References: <CAKbGBLjYWrooGZjZS_MaDe9kxacoaL9dHJM1oDe7_a-vQuhsJw@mail.gmail.com> <20140721132937.GF12921@htj.dyndns.org> <CAKbGBLj4c_bbN-GV-DTJWT7+iKLBauxvvu0uDvtQQOLMmx4N5A@mail.gmail.com> <20140723175021.GA14128@amazon.com>
In-Reply-To: <20140723175021.GA14128@amazon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 19:50, schrieb Steven Noonan:
> (Oops, LKML doesn't like rich text, resending. Was trying to avoid
> GMail's bad line wrapping. Going to use Mutt instead.)
>
> I'm starting to wonder if it's bad RAM or something. Just got a couple of
> worrying warnings on boot from the same system (after it spontaneously
> rebooted, with nothing revealing in the previous boot's logs).

I once had such too and since then I'm using memtest=3 in my kernel 
command line on x86* machines. Depending on the amount of RAM it will 
slow down boot by a few seconds, but if you don't care if your machine 
comes up in 5 or 10 seconds, it is a no-brainer.

Regards,

Alexander Holler
