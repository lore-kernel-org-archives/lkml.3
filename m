Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760453AbaCUOeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:34:19 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40408 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaCUOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:34:18 -0400
Message-ID: <532C4DE3.1040501@gmail.com>
Date: Fri, 21 Mar 2014 20:04:11 +0530
From: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: patch to add support for rtc ds1347
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i have made following modification in the 
patch i have sent previously for adding
support to maxim dallas rtc ds1347

1. space after and before /* and */ respectively
2. removed extra line space
3. added licence as GPL v2
4. changed 
	 if (dt->tm_year >= 100) 
                dt->tm_year -= 100; 
	
	dt->tm_year = dt->tm_year % 100;

I am sending the driver patch in next mail 

Thanks and regards
Raghavendra C Ganiga
