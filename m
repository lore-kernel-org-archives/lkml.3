Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaFAMKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 08:10:17 -0400
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:48372 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbaFAMKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 08:10:15 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2014 08:10:15 EDT
Message-ID: <538B16C8.8090900@linicks.net>
Date: Sun, 01 Jun 2014 13:04:24 +0100
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.14.5
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting hundreds of the same build warnings on this release - 
usually I get none - typical warnings:

include/linux/sched.h:1691: warning: ‘pid_alive’ declared inline after 
being called
include/linux/sched.h:1691: warning: previous declaration of ‘pid_alive’ 
was here

Info:

Machine AMD64
gcc version 4.2.4

Any more info required please CC me.

Nick
-- 
"A bug in the code is worth two in the documentation."
FSF Associate Member 5508
http://linicks.net/
http://pi.linicks.net/
