Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaEXKwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 06:52:51 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:53458 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaEXKwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 06:52:50 -0400
Date: Sat, 24 May 2014 18:50:47 +0400
From: Anton Saraev <antonysaraev@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Jake Edge <jake@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 0/3] staging/skein: more cleanup
Message-ID: <20140524145046.GA1844@Ruffial>
References: <20140520075612.220a13ae@chukar.edge2.net>
 <20140520144757.GA8664@titan.lakedaemon.net>
 <20140520102411.413d565d@chukar.edge2.net>
 <20140520215217.GB1692@Ruffial>
 <20140522105206.0115e1a4@chukar.edge2.net>
 <20140522170441.GW8664@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522170441.GW8664@titan.lakedaemon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 01:04:41PM -0400, Jason Cooper wrote:
> I do not, I'm unsure if Anton has anything pending capable of
> upstreaming.

I have two simple patches. But I don't know is it necessary to send
this patches. First is export of functions in *api.c files.
But it is trivial part of api cleanup. Second is fixing of remaining
uppercase X in skein_block.c. But this variables lie on SKEIN_DEBUG
compile path and maybe will be completely removed (or we need add
some output in the appropriate functions).
