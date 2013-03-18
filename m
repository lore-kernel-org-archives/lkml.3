Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3CROs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:48:59 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:42770 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3CROs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:48:58 -0400
Message-ID: <51472956.80209@gmail.com>
Date: Mon, 18 Mar 2013 15:48:54 +0100
From: Sergio Callegari <sergio.callegari@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Stable kernel 3.8.3 appears to break displayport on intel gen4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

     hope sending this message here is OK. In case it is not please take my 
apology.

This is just a short note to let you know that after installing 3.8.3, display 
port stopped working on my laptop. Going back to 3.8.2 brought it back to life.
This has been tested with the ubuntu mainline kernels that should be vanilla 
stable kernels. Hope this is not an incorrect report due to something wrong on 
their side. Laptop is a DELL E6500 with intel gen4 integrated graphics (Intel 
Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)).
With 3.8.3, xrandr does not report anymore the external monitor when it is 
actually attached via displayport.

Thanks for the attention and best regards,

Sergio Callegari
