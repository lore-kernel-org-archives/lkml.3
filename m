Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab3CULuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:50:23 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36865 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab3CULuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:50:19 -0400
Message-ID: <514AF3F5.6060702@gmail.com>
Date: Thu, 21 Mar 2013 12:50:13 +0100
From: Sergio Callegari <sergio.callegari@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel panic on stable kernel 3.8.2 when closing bluetooth dun
 connection
References: <51498CFE.9060804@gmail.com> <20130320161712.GA27840@kroah.com>
In-Reply-To: <20130320161712.GA27840@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/2013 17:17, Greg KH wrote:
> Have you notified the linux bluetooth developers about this? Is this new in 
> 3.8.2 and 3.8.1 or 3.8 works fine? thanks, greg k-h 

Hi, thanks for the advice.

I have verified that the issue was introduced with 3.8.0 and is not due to 
stabilization patches in the 3.8.x series. 3.7.x is fine (from x=0 to x=8)
Sorry for not having checked earlier, but I was incorrectly taken for granted 
that if the bug was back in 3.8.0 someone would have noticed already...
Now notifying the bluetooth developers too.

Sergio
