Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaKDAgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:36:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaKDAgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:36:14 -0500
Date: Mon, 3 Nov 2014 16:36:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Marek Belisko <marek.belisko@gmail.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH V2 2/2] ASoC: staging: ft1000: Logging message neatening
Message-ID: <20141104003613.GA5128@kroah.com>
References: <cover.1415060503.git.joe@perches.com>
 <a7140e598b199bbc7cb93d0a62d7e6240aa563c2.1415060503.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7140e598b199bbc7cb93d0a62d7e6240aa563c2.1415060503.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:25:44PM -0800, Joe Perches wrote:
> Use a more common logging style.
> 
> o Convert DEBUG macros to pr_debug
> o Add pr_fmt
> o Remove embedded function names from pr_debug
> o Convert printks to pr_<level>
> o Coalesce formats and align arguments
> o Add missing terminating newlines
> 
> Signed-off-by: Joe Perches <joe@perches.com>

ASoC???

I'll go edit that by hand...

