Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3AXP5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:57:11 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:45076 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab3AXP5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:57:08 -0500
Message-ID: <510159D2.7000001@cc.hut.fi>
Date: Thu, 24 Jan 2013 17:57:06 +0200
From: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <ljkarkk2@cc.hut.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CPU soft lockup in usb-audio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've spent months hunting for this random crash bug until today when I 
finally found a way to reliably reproduce it (run a software that I 
develop under valgrind). Log received over netconsole:

http://pastie.org/5848168

Is this a known issue or do you need more information to debug it?
