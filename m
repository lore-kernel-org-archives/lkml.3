Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab3FJGaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 02:30:17 -0400
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:47263 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3FJGaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 02:30:14 -0400
Message-ID: <51B57266.9050107@de.bosch.com>
Date: Mon, 10 Jun 2013 08:29:58 +0200
From: Dirk Behme <dirk.behme@de.bosch.com>
Organization: Robert Bosch Car Multimedia GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oded Gabbay <ogabbay@advaoptical.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob@landley.net" <rob@landley.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 3/3] MMC: FSL SDHC: Add support for hard-wired (permanent)
 card. Kernel version 3.4.47
References: <1370155128-680-1-git-send-email-ogabbay@advaoptical.com>
In-Reply-To: <1370155128-680-1-git-send-email-ogabbay@advaoptical.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.218.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.06.2013 08:38, Oded Gabbay wrote:
> This patch adds support of recognizing hard-wired (permanent) cards
> to Freescale's SDHC host driver. This is done by adding the option
> "fsl,card-wired" to the SDHC device-tree entry. Detection of this
> option is done in the probe function. Update documentation in file
> fsl-esdhc.txt

Why don't you want to introduce "fsl,card-wired"? Why don't you use 
"non-removable"?

To my understanding the patch

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7f217794ffa72f208a250b79ab0b7ea3de19677f

explicitly removed "fsl,card-wired". So I don't think re-introducing it 
is a good idea?

Best regards

Dirk
