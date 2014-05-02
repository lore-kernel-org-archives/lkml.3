Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaEBMrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:47:47 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39476 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaEBMrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:47:45 -0400
Message-ID: <536393EC.9050501@gmail.com>
Date: Fri, 02 May 2014 18:17:40 +0530
From: RAGHAVENDRA GANIGA <ravi23ganiga@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: i2c: add support for sc18im700 master i2c bus controller with uart
 interface
References: <5363939A.2040706@gmail.com>
In-Reply-To: <5363939A.2040706@gmail.com>
X-Forwarded-Message-Id: <5363939A.2040706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i am currently writing algorithm driver support for 
sc18im700 Master i2c bus controller with uart interface

since i am writing algorithm support which is similar to 
pcf8584 adapters so i have selected the 
drivers/i2c/algos/ directory for the driver file

so whether the directory i have selected is correct 

also if you have any comment on driver. please 
provide the feedback.

Thanks and Regards


