Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaJBHjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:39:49 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33491 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaJBHjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:39:48 -0400
Message-ID: <542D013E.6030800@gmail.com>
Date: Thu, 02 Oct 2014 09:39:42 +0200
From: Nitin Kuppelur <nitinkuppelur@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8712 removed unnecessary else after return
References: <1412174651-21418-1-git-send-email-nitinkuppelur@gmail.com> <1412185449.3247.18.camel@joe-AO725>
In-Reply-To: <1412185449.3247.18.camel@joe-AO725>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Perhaps a more common style is to use:
> 
> 	if (!padapter->halpriv.hal_bus_init ||
> 	    padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
> 		return _FAIL;
> 
> 
Agreed. I will send updated patch.

Regards,
Nitin
