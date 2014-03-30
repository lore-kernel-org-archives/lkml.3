Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaC3U7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 16:59:36 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:58977 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaC3U7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 16:59:34 -0400
X-Originating-IP: 76.119.93.133
Message-ID: <533885B0.5010001@desfo.org>
Date: Sun, 30 Mar 2014 16:59:28 -0400
From: Ryan <ryan@desfo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-pci@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: changed '...pci_bus* bus' to '...pci_bus *bus'
References: <1396034018-5645-1-git-send-email-ryan@desfo.org>
In-Reply-To: <1396034018-5645-1-git-send-email-ryan@desfo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is my first patch.  I'm looking for feedback pertaining to my
submission that way I can submit more patches correctly in the future. 
Any constructive feedback is welcome.

I have one question in particular regarding the 'Sign by' section in the
git commit message.  Am I suppose to add a 'Sign by' line for myself or
is that for the core kernel team?

Thank you for time and feedback,
Ryan

On 03/28/2014 03:13 PM, Ryan Desfosses wrote:
>    change made to resolve following checkpatch message:
>        drivers/pci/pci.c:109: ERROR: "foo* bar" should be "foo *bar"
> ---
>  drivers/pci/pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index fdbc294..a50d542 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -106,7 +106,7 @@ static bool pcie_ari_disabled;
>   * Given a PCI bus, returns the highest PCI bus number present in the set
>   * including the given PCI bus and its list of child PCI buses.
>   */
> -unsigned char pci_bus_max_busnr(struct pci_bus* bus)
> +unsigned char pci_bus_max_busnr(struct pci_bus *bus)
>  {
>  	struct list_head *tmp;
>  	unsigned char max, n;

