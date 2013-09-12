Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3ILW3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:29:31 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:35357 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab3ILW31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:29:27 -0400
Message-ID: <52324046.5060709@lwfinger.net>
Date: Thu, 12 Sep 2013 17:29:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: smatch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Smatch messages that are not understood
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am in the process of fixing smatch warnings and errors in the rtlwifi family 
of drivers. Most are straight forward; however, some routines show info messages 
originating from an inline routine in the header files as follows:

   CHECK   drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
include/linux/etherdevice.h:278 ether_addr_equal_64bits() info: ignoring 
unreachable code.
include/linux/etherdevice.h:278 ether_addr_equal_64bits() info: ignoring 
unreachable code.

The source code is a current pull of the mainline git tree. I'm not sure if this 
is a subtle case of unreachable code that I do not see, or if it is a smatch bug.

Thanks,

Larry
