Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaGUOtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:49:39 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:48892 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932789AbaGUOsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:48:51 -0400
Message-ID: <1405954117.6962.37.camel@rhapsody>
Subject: Re: [PATCH 2/25] BusLogic: Replace DEFINE_PCI_DEVICE_TABLE macro use
From: Khalid Aziz <khalid@gonehiking.org>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 21 Jul 2014 08:48:37 -0600
In-Reply-To: <1405697232-11785-3-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
	 <1405697232-11785-3-git-send-email-benoit.taine@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 17:26 +0200, Benoit Taine wrote:
> We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
> kernel coding style guidelines. This issue was reported by checkpatch.
> 
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> 
> ---
> Tested by compilation without errors.
> 
>  drivers/scsi/BusLogic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 972f817..64c7514 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -3893,7 +3893,7 @@ __setup("BusLogic=", blogic_setup);
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
>  	{ }
>  };*/
> -static DEFINE_PCI_DEVICE_TABLE(blogic_pci_tbl) = {
> +static const struct pci_device_id blogic_pci_tbl[] = {
>  	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER)},
>  	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC)},
>  	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT)},
> 

Acked-by: Khalid Aziz <khalid@gonehiking.org>


