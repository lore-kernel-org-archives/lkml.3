Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaEXRw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 13:52:28 -0400
Received: from blu0-omc1-s33.blu0.hotmail.com ([65.55.116.44]:39149 "EHLO
	blu0-omc1-s33.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbaEXRwY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 13:52:24 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 May 2014 13:52:24 EDT
X-TMN: [22gMz0bjhO1ZaM1FosRqoM2gp6jNxf1udlzFh/w5gKw=]
X-Originating-Email: [draj187@hotmail.com]
Message-ID: <BLU185-W275C18480BC12C148190C5EC390@phx.gbl>
From: Deepa Raj <draj187@hotmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: CMWQ workqueue questions
Date: Sat, 24 May 2014 17:47:17 +0000
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 May 2014 17:47:17.0844 (UTC) FILETIME=[348C8940:01CF7778]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was trying to understand the workqueues in more details:

e.g. it is given

kworker/u4:0
kworker/0:0

What does u4:0 represents and similarily 0:0 represents. I was glancing into the code when pool->cpu>0, there is u appended.

Can you please explain u4:0 and 0:0 (what does it represent) in workqueue kworker?
Regards,

D. Raj 		 	   		  