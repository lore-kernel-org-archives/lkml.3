Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbbAQJnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 04:43:35 -0500
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:58222 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbbAQJnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 04:43:32 -0500
Message-ID: <54BA2EC1.8060606@linicks.net>
Date: Sat, 17 Jan 2015 09:43:29 +0000
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.18.3
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.01.2015, Heinz Diehl wrote:

 > Since 3.18, machines with Ironlake Intel Graphics are left with a
 > black screen when booting into X. I reported the bug here:
 >
 > https://www.libreoffice.org/bugzilla/show_bug.cgi?id=87330

Yes (since 3.18.), and on my notebook with:

00:02.0 VGA compatible controller: Intel Corporation Atom Processor 
D4xx/D5xx/N4xx/N5xx Integrated Graphics Controller
00:02.1 Display controller: Intel Corporation Atom Processor 
D4xx/D5xx/N4xx/N5xx Integrated Graphics Controller

if I use the Intel sna driver, just running glxgears crashes X to the 
console, and videos run in mplayer but just appear black.  Strangely 
enough, after X crashes, if I restart it, all works fine?

I am currently using the Intel uxa driver which works OK on any occasion.

The above symptoms are still the same in 3.18.3

Nick
-- 
"A bug in the code is worth two in the documentation."
http://linicks.net/
http://slackpi.linicks.net/
http://fishpi.linicks.net/
