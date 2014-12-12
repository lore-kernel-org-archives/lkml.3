Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031188AbaLLR6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:58:37 -0500
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:46370 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935219AbaLLR6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:58:35 -0500
X-Greylist: delayed 1275 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2014 12:58:35 EST
Message-ID: <548B27CC.2060507@nsn.com>
Date: Fri, 12 Dec 2014 23:07:16 +0530
From: Sriram Raghunathan <sriram.r@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: About ARP state change from Delay to Stale
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 367
X-purgate-ID: 151667::1418405838-0000658F-5541BB47/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    I'd a question about ARP entry state change from DELAY to STALE. I'm
    referring to 3.10 Master kernel, where this particular state change 
is not notified on neigh_update. In  case, on creating a patch for the 
same, would it affect the kernel behavior ?

    Could you please share as why this state change is not notified 
right now?

Sriram
