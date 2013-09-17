Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3IQLOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:14:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46079 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab3IQLON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:14:13 -0400
Message-ID: <52383998.6080504@ti.com>
Date: Tue, 17 Sep 2013 16:44:32 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: old trees
References: <20130917170124.0afa2e103a9977355ad7c72c@canb.auug.org.au>
In-Reply-To: <20130917170124.0afa2e103a9977355ad7c72c@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tuesday 17 September 2013 12:31 PM, Stephen Rothwell wrote:
> Hi all,
> 
> This message is bcc'd to each of the contacts for the trees listed below,
> so apologies if you get two copies.
> 
> I have been inspired to check the ages of the trees included in
> linux-next.  Below I have listed all the trees that have not been
> commited to in the past 6 months.  Please let me know if the tree is not
> longer in use.  I don't mind keeping these trees in linux-next if they
> will have continued use, but would like to remove any that are no longer
> needed.
> 
> Tree		Last commit
> ----		-----------

> davinci		2 years, 2 months ago

You can remove the davinci tree from linux-next since the patches are
now reaching linux-next through ARM-SoC tree. Apologies for not asking
you to remove it for so long.

Regards,
Sekhar

