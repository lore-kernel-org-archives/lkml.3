Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3CUTiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:38:05 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:15124 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3CUTiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:38:04 -0400
Message-ID: <514B6199.8080306@tilera.com>
Date: Thu, 21 Mar 2013 15:38:01 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: remove two outdated Kconfig entries
References: <1363893139.1390.151.camel@x61.thuisdomein>
In-Reply-To: <1363893139.1390.151.camel@x61.thuisdomein>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/2013 3:12 PM, Paul Bolle wrote:
> Tile support got added in v2.6.36. Its main Kconfig file was added with
> two outdated Kconfig entries. DEFAULT_MIGRATION_COST is unused since
> v2.6.23, and SEMAPHORE_SLEEPERS is unused since v2.6.26. Remove these
> outdated entries now.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>

Thanks - taken into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

