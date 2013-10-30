Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3J3Qka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:40:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35717 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab3J3Qk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:40:28 -0400
Date: Wed, 30 Oct 2013 17:40:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aristeu Rozanski <arozansk@redhat.com>
Cc: linux-edac@vger.kernel.org, tony.luck@intel.com,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/12] sb_edac: move PCI IDs to pci_ids.h
Message-ID: <20131030164020.GF13290@pd.tnic>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
 <1383150426-24730-2-git-send-email-arozansk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1383150426-24730-2-git-send-email-arozansk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:26:55PM -0400, Aristeu Rozanski wrote:
> According to the comment, it should be done before submitting upstream.
> 
> Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
> ---
>  drivers/edac/sb_edac.c  |   21 ++-------------------
>  include/linux/pci_ids.h |   11 +++++++++++
>  2 files changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> index e04462b..4cdd948 100644
> --- a/drivers/edac/sb_edac.c
> +++ b/drivers/edac/sb_edac.c
> @@ -57,26 +57,9 @@ static int probed;
>   */
>  
>  /*
> - * FIXME: For now, let's order by device function, as it makes
> - * easier for driver's development process. This table should be
> - * moved to pci_id.h when submitted upstream

Why, is anything else besides sb_edac.c using those?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
