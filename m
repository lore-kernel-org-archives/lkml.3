Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3F2Vww (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 17:52:52 -0400
Received: from mta41.charter.net ([216.33.127.83]:58305 "EHLO
	mta41.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3F2Vws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:52:48 -0400
X-Authority-Analysis: v=2.0 cv=Cp/n6QED c=1 sm=1
 a=NeBweSrFeIqEG5ng+mIGTA==:17 a=01NHlALvFY8A:10 a=yUnIBFQkZM0A:10
 a=8nJEP1OIZ-IA:10 a=hOpmn2quAAAA:8 a=ag1SF4gXAAAA:8 a=fxJcL_dCAAAA:8
 a=TKhY4cnQ1aUB-msDav4A:9 a=wPNLvfGTeEIA:10 a=1TSTQ8KKaH4A:10
 a=NeBweSrFeIqEG5ng+mIGTA==:117
X-Auth-id: cmFjb3JiaW4yMDEwQGNoYXJ0ZXIubmV0
Message-ID: <51CF572F.3040400@charter.net>
Date: Sat, 29 Jun 2013 16:52:47 -0500
From: Richard Corbin <racorbin2010@charter.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: A Bug in 3.9.8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks:

I sent the indented text to gregkh@linuxfoundation.org, inappropriately 
as I suspected. I got a polite automated response suggesting alternate 
destinations for my email. To my non-technical eyes, your addresses 
seemed most appropriate.

     "Mr. Kroah-Hartman,

     "Excuse me for bothering you, but I do not know where to report my 
problem and I found your name in 
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.9.8-saucy/BUILD.LOG.

     "I am running Linux Mint KDE v15, but I like to run the latest 
kernel. I have never had a problem before installing the latest "general 
release" kernel from http://kernel.ubuntu.com/~kernel-ppa/mainline/ 
until yesterday.

     "After I installed v3.9.8-saucy, the system could no longer "read" 
cpu usage of my quad-core Intel  q6600. Conky, "top", "mpstat -P ALL" 
all show ZERO CPU usage. Everything else is fine; it is just the 
reporting that is busted.

     "If you are the wrong person and cannot forward to correct 
destination, then I am sorry for wasting your time."

I neglected to write that when I rebooted the identical system using 
v3.9.7-saucy as the kernel, the CPU usage for each core was registering 
non-zero values when appropriate as usual.

Cordially,
Richard Corbin

