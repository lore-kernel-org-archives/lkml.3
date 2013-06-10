Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3FJNnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:43:47 -0400
Received: from mail.advaoptical.com ([91.217.199.15]:60322 "EHLO
	mail.advaoptical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3FJNnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:43:45 -0400
Message-ID: <51B5D7F0.4050708@advaoptical.com>
Date: Mon, 10 Jun 2013 16:43:12 +0300
From: Oded Gabbay <ogabbay@advaoptical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dirk Behme <dirk.behme@de.bosch.com>
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
References: <1370155128-680-1-git-send-email-ogabbay@advaoptical.com> <51B57266.9050107@de.bosch.com>
In-Reply-To: <51B57266.9050107@de.bosch.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.179.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-10_02:2013-06-10,2013-06-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dirk,

You are absolutely right.
I will revise my patch series to reflect the change.
Basically, I will call the generic mmc_of_parse from the probe function 
of Freescale's driver.
That will handle all the additional capabilities.

Thanks
Oded

On 06/10/2013 09:29 AM, Dirk Behme wrote:
> On 02.06.2013 08:38, Oded Gabbay wrote:
>> This patch adds support of recognizing hard-wired (permanent) cards
>> to Freescale's SDHC host driver. This is done by adding the option
>> "fsl,card-wired" to the SDHC device-tree entry. Detection of this
>> option is done in the probe function. Update documentation in file
>> fsl-esdhc.txt
>
> Why don't you want to introduce "fsl,card-wired"? Why don't you use 
> "non-removable"?
>
> To my understanding the patch
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7f217794ffa72f208a250b79ab0b7ea3de19677f 
>
>
> explicitly removed "fsl,card-wired". So I don't think re-introducing 
> it is a good idea?
>
> Best regards
>
> Dirk

