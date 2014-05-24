Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaEXRxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 13:53:42 -0400
Received: from blu0-omc1-s27.blu0.hotmail.com ([65.55.116.38]:33640 "EHLO
	blu0-omc1-s27.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694AbaEXRxk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 13:53:40 -0400
X-TMN: [AAy/1koD/IISJHosOMIs+3+xsEfaXIXLi1u2Dkugu/E=]
X-Originating-Email: [draj187@hotmail.com]
Message-ID: <BLU185-W27F95435429B32310240F6EC390@phx.gbl>
From: Deepa Raj <draj187@hotmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: CMWQ workqueue questions
Date: Sat, 24 May 2014 17:48:33 +0000
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 24 May 2014 17:48:33.0579 (UTC) FILETIME=[61B0C7B0:01CF7778]
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