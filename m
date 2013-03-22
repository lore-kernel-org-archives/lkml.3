Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422818Ab3CVUFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:05:24 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:44856 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422705Ab3CVUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:05:23 -0400
Message-ID: <514CB982.8070206@tilera.com>
Date: Fri, 22 Mar 2013 16:05:22 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        <linux-xtensa@linux-xtensa.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: remove KCORE_ELF again
References: <1363912851.1390.170.camel@x61.thuisdomein>  <514CB496.3080100@tilera.com> <1363982392.1390.181.camel@x61.thuisdomein>
In-Reply-To: <1363982392.1390.181.camel@x61.thuisdomein>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/2013 3:59 PM, Paul Bolle wrote:
> On Fri, 2013-03-22 at 15:44 -0400, Chris Metcalf wrote:
>> I took the tile part of this patch into the tile tree.  Thanks!
> Should I (try to) remember to send future patches for tile, if any,
> separately?

I think it's generally slightly easier for the arch maintainers to take changes that are just for their own arch, but it's not too hard to split out the per-arch piece, either.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

