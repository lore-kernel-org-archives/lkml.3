Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3JHOIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:08:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25857 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3JHOIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:08:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+r9QdGmhbt5vWkcrje+ARIt6hfrgZv+C4=
Date: Tue, 8 Oct 2013 10:08:07 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: manual merge of the mvebu tree
Message-ID: <20131008140807.GG5402@titan.lakedaemon.net>
References: <1381239855-16314-1-git-send-email-treding@nvidia.com>
 <1381239855-16314-3-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381239855-16314-3-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 03:44:13PM +0200, Thierry Reding wrote:
> Today's linux-next merge of the mvebu tree got conflicts in:
> 
> 	arch/arm/mach-dove/board-dt.c
> 
> caused by commits ffe195c (ARM: dove: remove legacy pcie and clock init),
> e3730b4 (ARM: dove: switch to DT probed mbus address windows), and 51e40f5
> (ARM: dove: remove custom .init_time hook).
> 
> I fixed them up (see below). Please verify that the resolution looks
> correct.

Looks good to me, thanks!

thx,

Jason.
