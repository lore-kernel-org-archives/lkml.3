Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab3JWPGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 11:06:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab3JWPGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 11:06:46 -0400
Message-ID: <5267E601.208@suse.cz>
Date: Wed, 23 Oct 2013 17:06:41 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: haver@linux.vnet.ibm.com
Cc: Frank Haverkamp <haver@vnet.ibm.com>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver
References: <1374740897-20304-1-git-send-email-haver@vnet.ibm.com>  <1374740897-20304-2-git-send-email-haver@vnet.ibm.com>  <51F12668.8000400@suse.cz> <1382534154.2791.8.camel@oc7383187364.ibm.com>  <20131023134059.GB21936@sepie.suse.cz> <1382537663.4940.7.camel@oc7383187364.ibm.com>
In-Reply-To: <1382537663.4940.7.camel@oc7383187364.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.10.2013 16:14, Frank Haverkamp wrote:
> of course you are right. Let me try again.
> 
> I hope this looks better now:
> + dev_info(&pci_dev->dev, "GenWQE driver version: %s %s%u\n",
> + DRV_VERS_STRING, GENWQE_DEVNAME, cd->card_idx);
> ...

There is no __TIME__/__DATE__ macro now, which is good, but as Greg
points out, the patch contains extra line breaks and cannot be applied.
The easiest is to send patches using git send-email to avoid this.

Michal
