Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaHLFBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:01:44 -0400
Received: from mtaout24.012.net.il ([80.179.55.180]:41944 "EHLO
	mtaout24.012.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaHLFBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:01:43 -0400
Date: Tue, 12 Aug 2014 08:01:41 +0300
From: Oren Twaig <oren@scalemp.com>
Subject: x86: vmalloc and THP
X-012-Sender: ira_oren@012.net.il
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Message-id: <53E99FB5.1020506@scalemp.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Antivirus: avast! (VPS 140811-1, 08/11/2014), Outbound message
X-Antivirus-Status: Clean
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Does memory allocated using vmalloc() will be mapped using huge pages 
either directly or later by THP ?

If not, is there any fast way to change this behavior ? Maybe by 
changing the granularity/alignment of such allocations to allow such 
mapping ?

Thanks,
Oren Twaig.

---
This email is free from viruses and malware because avast! Antivirus protection is active.
http://www.avast.com

