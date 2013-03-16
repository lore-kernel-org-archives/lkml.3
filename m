Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3CPMqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 08:46:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46020 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab3CPMqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 08:46:17 -0400
Message-ID: <5144698B.9080703@ti.com>
Date: Sat, 16 Mar 2013 08:46:03 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 00/50] staging: omap-thermal: several code refactoring
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com> <20130316090540.GQ9138@mwanda>
In-Reply-To: <20130316090540.GQ9138@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,

On 16-03-2013 05:05, Dan Carpenter wrote:
> I've reviewed this set.
>
> I hate to make people redo whole patchset sets, and I hate
> re-reviewing code.  Obviously, I don't really like the bunny hop
> patches and I'm trying to discourage that going forward.  ;P  But
> I wouldn't say it's a "Redo the whole thing" kind of problem.
>
> Could just resend patch 33 and 47?  You should probably be able to
> redo those without changing the rest.

I could of course change them if the comment is better clarified. As I 
mentioned as reply to one of your comments, those changes are following 
what is suggested in CodingStyle file.

I can of course send a diff on top of 33, to fix the introduce bug.

For 47, I'm not sure the comment is fully applicable.

>
> regards,
> dan carpenter
>
>
>

