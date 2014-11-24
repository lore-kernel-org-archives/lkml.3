Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaKXNQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:16:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbaKXNQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:16:22 -0500
Message-ID: <54732FA4.1090603@suse.de>
Date: Mon, 24 Nov 2014 14:16:20 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org
CC: Christoph Hellwig <hch@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] eeprom-93cx6: Add (read-only) support for 8-bit mode
References: <1416831074-24282-1-git-send-email-linux@rainbow-software.org> <1416831074-24282-2-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1416831074-24282-2-git-send-email-linux@rainbow-software.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 01:11 PM, Ondrej Zary wrote:
> Add read-only support for EEPROMs configured in 8-bit mode (ORG pin connected
> to GND).
> This will be used by wd719x driver.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 21284 (AG Nürnberg)
