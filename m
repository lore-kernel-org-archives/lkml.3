Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3FDJZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:25:18 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:19266 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3FDJZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:25:14 -0400
X-IronPort-AV: E=Sophos;i="4.87,798,1363132800"; 
   d="scan'208";a="5292412"
Message-ID: <1370337912.24512.91.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v2 4/5] arm64/xen: use XEN_IO_PROTO_ABI_ARM on ARM64
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <konrad.wilk@oracle.com>
Date: Tue, 4 Jun 2013 10:25:12 +0100
In-Reply-To: <1370273624-26976-4-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
	 <1370273624-26976-4-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 16:33 +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

> ---
>  include/xen/interface/io/protocols.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/xen/interface/io/protocols.h b/include/xen/interface/io/protocols.h
> index 0eafaf2..056744b 100644
> --- a/include/xen/interface/io/protocols.h
> +++ b/include/xen/interface/io/protocols.h
> @@ -15,7 +15,7 @@
>  # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_IA64
>  #elif defined(__powerpc64__)
>  # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_POWERPC64
> -#elif defined(__arm__)
> +#elif defined(__arm__) || defined(__aarch64__)
>  # define XEN_IO_PROTO_ABI_NATIVE XEN_IO_PROTO_ABI_ARM
>  #else
>  # error arch fixup needed here


