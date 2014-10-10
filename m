Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaJJWgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:36:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaJJWgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:36:17 -0400
Date: Fri, 10 Oct 2014 15:35:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mike Skoog <mskoog@endruntechnologies.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mkorreng <mkorreng@endruntechnologies.com>
Subject: Re: Kernel Patch to add Endrun PCIe PTP card v1 (2/2)
Message-ID: <20141010223519.GA1843@kroah.com>
References: <54384D76.6050708@endruntechnologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54384D76.6050708@endruntechnologies.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 02:19:50PM -0700, Mike Skoog wrote:
> =====================================================
> Subject: [PATCHv1 2/2] 8250_pci: pci.ids: EndRun Technologies PTP PCIe
> card recognition.
> From: Michael Skoog <mskoog@endruntechnologies.com>
> 
> Add recognition of EndRun Technologies PCIe PTP slave card
> and setups two ttySx ports to communicate to the card for
> retrieval of PTP based time and to communicate with the card's
> Linux OS.
> 
> Signed-off-by: Michael Skoog <mskoog@endruntechnologies.com>
> Signed-off-by: Mike Korreng <mkorreng@endruntechnologies.com>
> 
> ---
> 
> The kernel patch is currently against linux 3.17 kernel, for the x86
> architecture.
> 
> The pci.ids patch is against the Slackware 13 distribution.
> 
> diffstat:
>  pci.ids |    2 ++
>  1 file changed, 2 insertions(+)

This doesn't go through kernel developers, it needs to go through the
maintainer of the pci.ids file, see the header of it for details.

