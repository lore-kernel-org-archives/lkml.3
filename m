Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3FXI1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:27:11 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:45654 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3FXI1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:27:09 -0400
Message-ID: <51C802DA.4080202@mentor.com>
Date: Mon, 24 Jun 2013 09:27:06 +0100
From: Dean Jenkins <Dean_Jenkins@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130523 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SLIP: Is there a maintainer for drivers/net/slip/slip.c ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2013 08:27:07.0769 (UTC) FILETIME=[9D699690:01CE70B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using the Linux v3.9 tag, I note that

./scripts/get_maintainer.pl -f drivers/net/slip/slip.c
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

There seems to be no maintainer for drivers/net/slip/slip.c, is that true ?

I am asking because sl_encaps() and slip_write_wakeup() do not handle 
error codes from tty->ops->write() and a recursive stack overflow crash 
can occur if the tty->ops->write() fails to write all the characters. I 
have some patches to fix this but would like some feedback on an 
appropriate solution.

Thanks,

Dean Jenkins
Mentor Graphics
