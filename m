Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965842AbaGRNru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:47:50 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:50409 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965410AbaGRNrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:47:35 -0400
Date: Fri, 18 Jul 2014 09:47:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, kishon@ti.com,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 3/8] ata: libahci_platform: move port_map parameters
 into the AHCI structure
Message-ID: <20140718134730.GA13012@htj.dyndns.org>
References: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405686607-8126-4-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405686607-8126-4-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 02:30:02PM +0200, Antoine Ténart wrote:
> @@ -321,6 +321,8 @@ struct ahci_host_priv {
>  	u32			cap;		/* cap to use */
>  	u32			cap2;		/* cap2 to use */
>  	u32			port_map;	/* port map to use */
> +	u32			force_port_map;	/* force port map */
> +	u32			mask_port_map;	/* mask out particular bits */

So, ->flags and ->force/mask_port_map are the only input ones, right?
Can we collect them to one spot and label them as such?

Thanks.

-- 
tejun
