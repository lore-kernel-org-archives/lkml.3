Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3EBHGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:06:18 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:60329 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3EBHGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:06:14 -0400
Message-ID: <51821068.2020101@prisktech.co.nz>
Date: Thu, 02 May 2013 19:06:16 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        a.zummo@towertech.it, rtc-linux@googlegroups.com,
        akpm@linux-foundation.org
Subject: [PATCH 29/30] rtc: rtc-vt8500: use devm_rtc_device_register()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realise this is a rather trivial series but it would be nice if the 
listed maintainers for the drivers had been notified as well.

Regards
Tony Prisk
