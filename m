Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbaKMKZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:25:32 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:41653 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaKMKZb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Thu, 13 Nov 2014 05:25:31 -0500
Message-Id: <546495280200007800047203@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 13 Nov 2014 10:25:28 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: <x86@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Ingo Molnar" <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 2/3] x86: allow dma_get_required_mask()
 to be overridden
References: <1415805906-27316-1-git-send-email-david.vrabel@citrix.com>
 <1415805906-27316-3-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1415805906-27316-3-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.11.14 at 16:25, <david.vrabel@citrix.com> wrote:
> --- a/arch/x86/include/asm/device.h
> +++ b/arch/x86/include/asm/device.h
> @@ -13,4 +13,6 @@ struct dev_archdata {
>  struct pdev_archdata {
>  };
>  
> +#define ARCH_HAS_DMA_GET_REQUIRED_MASK

Is there a particular reason you put this here rather than in
dma-mapping.h?

Jan

