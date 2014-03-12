Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaCLDGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:06:41 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57145 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaCLDGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:06:39 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <531FCF3D.8020409@roeck-us.net>
Date: Tue, 11 Mar 2014 20:06:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        clemens@ladisch.de, jdelvare@suse.de, rob@landley.net,
        lm-sensors@lm-sensors.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: andre@andrep.de
Subject: Re: [PATCH] hwmon, k10temp: Add support for AMD F16 M30h processor
References: <1394573159-2317-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
In-Reply-To: <1394573159-2317-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 02:25 PM, Aravind Gopalakrishnan wrote:
> Adding new PCI ID to support AMD F16 M30h processor (Mullins).
> While at it, modify Kconfig and Doc files to reflect the
> support for newer processors
>
> Note: PCI ID for this processor will make it into pci_ids.h
> as part of this patch:
> http://marc.info/?l=linux-kernel&m=139291362126057&w=2
> which should be pulled into 3.15 when merge window opens
> (It currently sits in 'for-next' branch of bp.git-
> https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/log/?h=for-next)
>
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Looks good. We'll have to see how we can apply this; probably after 3.15-rc1
comes out. I'll put it into my -staging branch for now and pull in the other
patch as well to make sure it compiles.

Guenter

