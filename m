Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3JMAm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 20:42:57 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:3065 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3JMAm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 20:42:56 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Oct 2013 20:42:55 EDT
Message-ID: <5259EABD.3060304@spin.net.au>
Date: Sun, 13 Oct 2013 10:35:09 +1000
From: Chris Jones <chrisjones@spin.net.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Shawn Starr <shawn.starr@rogers.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: No longer able to build kernel into RPM on Fedora
References: <2492370.jKSlzuQ6pe@segfault.sh0n.net>
In-Reply-To: <2492370.jKSlzuQ6pe@segfault.sh0n.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-0.48, required 4, AWL -0.57, BAYES_20 -0.01, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a temporary work around, can you revert to the older version of RPM?


Regards




On 10/13/2013 05:03 AM, Shawn Starr wrote:
> Hello folks,
>
> My usual approach to testing git snapshots of Linus's tree (with custom
> patches applied on top) is to make rpm and install this into my system for a
> clean add/remove of test kernels.
>
> However,  the developers of rpm removed the --target and -ta options, so I
> can't take tarball and build into RPM anymore.
>
> Since I last built custom RPM builds of Linus's tree was likely Fedora 18, it
> seems the option target got removed by 19.
>
> Any ideas, fixes?
>
> Thanks,
> Shawn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 

Chris Jones

Founder and Lead Software Architect
Paradise Software
chrisjones@spin.net.au

