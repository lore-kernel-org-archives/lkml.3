Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaAFL26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:28:58 -0500
Received: from tundra.namei.org ([65.99.196.166]:60301 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaAFL25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:28:57 -0500
Date: Mon, 6 Jan 2014 22:28:44 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: TPM Changes for 3.14
In-Reply-To: <201401060424.50738.PeterHuewe@gmx.de>
Message-ID: <alpine.LRH.2.02.1401062227080.4512@tundra.namei.org>
References: <201401040335.04980.PeterHuewe@gmx.de> <alpine.LRH.2.02.1401061321510.31564@tundra.namei.org> <201401060424.50738.PeterHuewe@gmx.de>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jan 2014, Peter H?we wrote:

> Hi James,
> 
> > Please generate this against my next branch.
> Here it is - note:
> I cherry-picked the changes that went through the xen tree before applying my changes.
> 
> The following changes since commit dcf4e392867bf98d50ad108ed7c2bfb941e8c33d:
> 
>   ima: remove unneeded size_limit argument from ima_eventdigest_init_common() (2014-01-03 07:43:00 -0500)
> 
> are available in the git repository at:
> 
>   https://github.com/PeterHuewe/linux-tpmdd for-james
> 

I need to resync my tree to recent Linus to bring in the prerequiste 
changes in the Xen code.  Then I can pull the original branch, once you 
publish it again.

Also, please cc the LSM list.


-- 
James Morris
<jmorris@namei.org>
