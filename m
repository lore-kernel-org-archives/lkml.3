Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaEXRxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 13:53:52 -0400
Received: from blu004-omc1s2.hotmail.com ([65.55.116.13]:53020 "EHLO
	BLU004-OMC1S2.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaEXRxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 13:53:50 -0400
X-TMN: [mTpahlLNFqvO/1q35AEtdjyKNe40/VtTKLyIYtITNmc=]
X-Originating-Email: [draj187@hotmail.com]
Message-ID: <BLU185-W300905E61724FF175DB342EC390@phx.gbl>
From: Deepa Raj <draj187@hotmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: CMWQ workqueue questions
Date: Sat, 24 May 2014 17:50:25 +0000
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 May 2014 17:50:25.0853 (UTC) FILETIME=[A49C6ED0:01CF7778]
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