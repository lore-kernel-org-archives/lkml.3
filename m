Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbaHHQxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:53:19 -0400
Received: from outrelay06.libero.it ([212.52.84.110]:39145 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbaHHQxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:53:17 -0400
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0201.53E50075.01A4,ss=1,re=0.000,fgs=0
X-libjamoibt: 1823
Message-ID: <53E501CD.60607@inwind.it>
Date: Fri, 08 Aug 2014 18:58:53 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Matt Helsley <matt.helsley@gmail.com>
CC: Jean Delvare <jdelvare@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it> <1407359103-6012-6-git-send-email-kreijack@inwind.it> <20140806231803.GA5643@roeck-us.net> <53E31694.8050107@gmail.com> <53E31AB0.6070604@roeck-us.net> <20140807085235.2c0e63dd@endymion.delvare> <53E32C77.5000804@roeck-us.net> <53E3BC48.4020304@inwind.it> <20140807211941.GA2756@eieio> <53E4E4B8.4060900@inwind.it> <53E4FB0D.7010500@roeck-us.net>
In-Reply-To: <53E4FB0D.7010500@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 06:30 PM, Guenter Roeck wrote:
> On 08/08/2014 07:54 AM, Goffredo Baroncelli wrote:
[...]
> I just noticed - hwmon_device_register_with_groups() returns ERR_PTR
> on errors, not NULL, so checking for a NULL return value won't help
> much if there is an error.

Thanks, due to this, in the next day I will issue a new revision.


> Guenter
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
