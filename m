Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3HKQac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:30:32 -0400
Received: from hotel311.server4you.de ([85.25.146.15]:50020 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3HKQab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:30:31 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Aug 2013 12:30:30 EDT
Message-ID: <5207BA00.3030709@monom.org>
Date: Sun, 11 Aug 2013 18:21:20 +0200
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Arend van Spriel <arend@broadcom.com>
Subject: brcsmac kernel panic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just updated my laptop (MacBook Air 2012) from 3.11-rc3+ to 3.11-rc4+ 
and since then brcsmac crashes short after enabling it. Unfortunately, I 
did also change some config flags in the area of cpufreq (enabling 
p-state driver) so the configuration is not exactly the same. Before I 
try to figure out what I have changed, I am posting the picture of the 
crash. Maybe it is something obvious.

v3.11-rc4-197-gd92581f
http://www.monom.org/misc/brcmsmac/v3.11-rc4.config
http://www.monom.org/misc/brcmsmac/IMAG0064.jpg

hth,
daniel
