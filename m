Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbaGaVVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:21:40 -0400
Received: from outrelay08.libero.it ([212.52.84.112]:46324 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaGaVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:21:39 -0400
X-libjamoibt: 1823
Message-ID: <53DAB49D.9000402@inwind.it>
Date: Thu, 31 Jul 2014 23:26:53 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] therm_windtunnel doesn't work properly on PowerMac
 G4
References: <53D95AAF.6030309@inwind.it>	<1406770020.4935.166.camel@pasglop> <20140731085211.5941bd33@endymion.delvare>
In-Reply-To: <20140731085211.5941bd33@endymion.delvare>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 08:52 AM, Jean Delvare wrote:
> Hi Ben, Goffredo,
> 
[...]
> 
> This leaves only two drivers still using the old binding model:
> macintosh/therm_pm72 and sound/ppc/keywest. Could any of you please
> convert these to the standard binding model so that I can finally get
> rid of i2c_driver.attach_adapter? That would be wonderful.

I will try to give a look of keywest, because I can (?) test the change.

I can't update therm_pm72 because I am not in position to test it. Anyway
Ben in the other email stated that it is obsolete by the windfarm_pm72.

> 
> Thanks again,
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
