Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990AbaKXVcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:32:08 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaKXVcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:32:06 -0500
Message-ID: <5473A3D3.4050205@nod.at>
Date: Mon, 24 Nov 2014 22:32:03 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andrew Murray <amurray@embedded-bits.co.uk>
CC: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH 1/2] UBI: Implement UBI_METAONLY
References: <1414594338-14695-1-git-send-email-richard@nod.at>	<CAPcvp5HBnuAHTwFHLJ1Ve6o2MSeQ8Qnn6x7Q0wD2G-yP6p7OLA@mail.gmail.com>	<54514BF6.1010201@nod.at> <CAPcvp5Eugd79bLV7e8kOL_Lhut1KeYYu5eZby9kQUee0j5sJqQ@mail.gmail.com>
In-Reply-To: <CAPcvp5Eugd79bLV7e8kOL_Lhut1KeYYu5eZby9kQUee0j5sJqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.11.2014 um 13:42 schrieb Andrew Murray:
>> Please send a patch for that. :)
> 
> Apologies for the delay - did you just want junk a hunk so you can
> include in your next revision - or did you want me to come up with a
> v2 of your patch?

I have to say sorry, your mail got lost in my inbox. :-(
The change in ubi.h is trivial, I've added it directly to my patch.
If you want you can send a patch for gluebi.c.

Thanks,
//richard
