Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbbAGGwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 01:52:40 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:57093 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbAGGwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 01:52:38 -0500
Date: Wed, 7 Jan 2015 07:52:35 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH v2 32/40] avr32: macro whitespace fixes
Message-ID: <20150107065235.GB18142@samfundet.no>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-33-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-33-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 06 Jan 2015 17:45:18 +0200 or thereabout, Michael S. Tsirkin wrote:
> While working on arch/avr32/include/asm/uaccess.h, I noticed
> that some macros within this header are made harder to read because they
> violate a coding style rule: space is missing after comma.
> 
> Fix it up.

Thank you (-:

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/asm/uaccess.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
