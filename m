Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaGKE5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 00:57:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59720 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaGKE5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 00:57:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BF66A2.2040109@roeck-us.net>
Date: Thu, 10 Jul 2014 21:22:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        herrmann.der.user@googlemail.com, jdelvare@suse.de,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon, fam15h_power: Remove needless pci dev id
References: <1405030560-2128-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
In-Reply-To: <1405030560-2128-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 03:16 PM, Aravind Gopalakrishnan wrote:
> PCI_DEVICE_ID_AMD_16H_NB_F4 can be obtained from it's
> definition in pci_ids.h. So we don't have to define it
> again here.
>
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

Applied to -next.

Thanks,
Guenter


