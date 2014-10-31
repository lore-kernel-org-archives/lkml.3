Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161748AbaJaCp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:45:29 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35797 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161609AbaJaCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:45:27 -0400
Date: Thu, 30 Oct 2014 19:45:13 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Robert Richter <rric@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        Stefan Assmann <sassmann@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH] VNIC: Adding support for Cavium ThunderX network
 controller
Message-ID: <20141030194513.089d27ec@urahara>
In-Reply-To: <20141030165434.GW20170@rric.localhost>
References: <20141030165434.GW20170@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014 17:54:34 +0100
Robert Richter <rric@kernel.org> wrote:

> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 1fa99a301817..80bd3336691e 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2324,6 +2324,8 @@
>  #define PCI_DEVICE_ID_ALTIMA_AC9100	0x03ea
>  #define PCI_DEVICE_ID_ALTIMA_AC1003	0x03eb
>  
> +#define PCI_VENDOR_ID_CAVIUM		0x177d

I don't think PCI folks want this updated with every id anymore.
