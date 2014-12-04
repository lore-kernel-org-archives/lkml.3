Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaLDWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:25:26 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47647 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaLDWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:25:25 -0500
Date: Thu, 4 Dec 2014 14:25:21 -0800
From: josh@joshtriplett.org
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: tinyconfig x86-32 vmlinux sizes by gcc compiler version
Message-ID: <20141204222521.GA20091@cloud>
References: <1417728779.2721.15.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417728779.2721.15.camel@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 01:32:59PM -0800, Joe Perches wrote:
> Just fyi.
> 
> At least for x86-32, it seems later versions of gcc
> are producing smaller images.
> 
> $ size vmlinux.*
>    text	   data	    bss	    dec	    hex	filename
>  657725	 118496	1189040	1965261	 1dfccd	vmlinux.4.4
>  633563	 118528	1189448	1941539	 1da023	vmlinux.4.6
>  633277	 118496	1189592	1941365	 1d9f75	vmlinux.4.7
>  632299	 121120	1192784	1946203	 1db25b	vmlinux.4.9

I would certainly hope that GCC's -Os gets better over time.  However, I
find the increase in data/bss and thus overall size in 4.9 concerning.
Any idea what that comes from?

- Josh Triplett
