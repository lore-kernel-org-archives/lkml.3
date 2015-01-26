Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbbAZVVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:21:39 -0500
Received: from or-71-0-52-80.sta.embarqhsd.net ([71.0.52.80]:53676 "EHLO
	asgard.dharty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbbAZVVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:21:36 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2015 16:21:35 EST
Message-ID: <54C6ADA0.6080606@dharty.com>
Date: Mon, 26 Jan 2015 13:12:00 -0800
From: catchall <catchall@dharty.com>
Reply-To: v4l@dharty.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Hauppage HVR-2250 - No Free Sequences
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/86259/match=hauppage+hvr+2250+no+free+sequences

Just wanted to add that Kyle is not alone in this.

I have also recently started having issues unable to get a tuner lock.  
I see my logs filled with lines like:

2015-01-26T12:30:44.387796-08:00 mediapc kernel: [95256.808510] 
saa7164_cmd_send() No free sequences
2015-01-26T12:30:44.387799-08:00 mediapc kernel: [95256.808512] 
saa7164_api_i2c_write() error, ret(1) = 0xc
2015-01-26T12:30:44.387801-08:00 mediapc kernel: [95256.808515] 
s5h1411_writereg: writereg error 0x19 0xf7 0x0001, ret == -5)

I have tried different combinations of the firmware at 
http://www.steventoth.net/linux/hvr22xx/ with no luck.

Regards,

David

