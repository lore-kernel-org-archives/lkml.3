Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbaCTUPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:15:51 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:56441 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbaCTUPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:15:49 -0400
Message-ID: <1395346547.29055.2.camel@x220>
Subject: Re: [PATCH] MAINTAINERS: microblaze: Use LKML as mailing list
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        microblaze-uclinux@itee.uq.edu.au,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Stephen Warren <swarren@nvidia.com>
Date: Thu, 20 Mar 2014 21:15:47 +0100
In-Reply-To: <4f187754982226c3456c0a9b86050ab4e470aa98.1395328176.git.michal.simek@xilinx.com>
References: <4f187754982226c3456c0a9b86050ab4e470aa98.1395328176.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2014 20:15:47.0741 (UTC) FILETIME=[2E692CD0:01CF4479]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 16:09 +0100, Michal Simek wrote:
> microblaze-uclinux mailing list is almost dead and
> it is just causing troubles for non subscribers which are
> getting email about waiting for moderator.
> Approval never happens. Move it to LKML.
> 
> Reported-by: Richard Guy Briggs <rgb@redhat.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b3fdb0f..1a22c62 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5702,7 +5702,7 @@ F:	fs/imgdafs/
> 
>  MICROBLAZE ARCHITECTURE
>  M:	Michal Simek <monstr@monstr.eu>
> -L:	microblaze-uclinux@itee.uq.edu.au (moderated for non-subscribers)
> +L:	linux-kernel@vger.kernel.org

Isn't lkml already the catch all address that get_maintainer.pl always
spits out?

>  W:	http://www.monstr.eu/fdt/
>  T:	git git://git.monstr.eu/linux-2.6-microblaze.git
>  S:	Supported


Paul Bolle

