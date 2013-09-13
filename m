Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3IMWha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 18:37:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52290 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab3IMWh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 18:37:28 -0400
Message-ID: <5233939B.3020401@zytor.com>
Date: Fri, 13 Sep 2013 15:37:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: access efi variables
References: <52333139.6020203@broadcom.com>
In-Reply-To: <52333139.6020203@broadcom.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 08:37 AM, Arend van Spriel wrote:
> I need to obtain a uefi variable so I went looking at the API in
> include/linux/efi.h. I found the following definition:
> 
> But according to the specs the variable I need to obtain is 2k bytes.
> Should I expect trouble :-p
> 

efivarfs doesn't have those limitations.

	-hpa


