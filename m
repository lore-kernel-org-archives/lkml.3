Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaCFUsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:48:16 -0500
Received: from nm49-vm3.bullet.mail.bf1.yahoo.com ([216.109.115.190]:21667
	"EHLO nm49-vm3.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752900AbaCFUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:48:13 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 15:48:13 EST
X-Yahoo-Newman-Id: 71705.87942.bm@smtp234.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: g32k9dIVM1m2VeeMFkyzLZI2bGkmyoSo22ASRlM3fKWvWCu
 0oS_TjLtfU42Ld3HhwXLYhUdqdgzND6Aj2rFsqCMali_479llp30r1KP8Zk7
 TEkGhGM1sKkN78wGzvemrhX.bIo2hIQRqp1YEy90t9IDSIsatI_NiaYkYJ1x
 rCQMH_aUYuAhpCP9hTfbjrs0RnarfjOX_dWmjtgHTSnnSUYd6hDK9tbYvWVB
 JtDW9EsOOgNsKn6VTNOyf.R2dhxj4UF8yuCh1yFvv4QEoqV1oLD2Krby0LO6
 3RQL0.tNLCL2SZ0pXqpU.1.7blWJ4KLwtNUmaFs6uwKY6koWaXvlIgg8Bx8_
 MDATS7VFg49lUeeNe6l2ZMpjACke0fbyPyZpm1GYrlgfqMCc4YxIyRFYRv5o
 y3KsXSl89xb21AHDMAX_GLVivQIHrxvAO2dC9vlLiCwcO.3K.MY21.GnYC1N
 BVcFtcVA7iiYIsGOmi.B6.uWFx3xtP2rT7CCaXZeauzIDQE_ra4hBmTu.1du
 1AqBvcvEAWa3mupceTIPFSbX3i9p71n0EuD9lRCQ58CMy0EDTBURvJQtMlZR
 1_4Acnf4L7j5w.aNmlxTqgd.B2r_G_.BHztcNes1YQRIFAJs3Q9gfagnEND8
 eorXfOv5TgXSZzw0z3eYICfOVyAiKhKPQTG0WWsOyrrnQ6gVtTa_qe60-
X-Yahoo-SMTP: u9r3j8eswBBsV5z1r5v0bR9cjPS77vatbJK.6sw-
X-Rocket-Received: from [163.238.113.35] (draconicpenguin1@163.238.113.35 with plain [98.139.211.125])
        by smtp234.mail.bf1.yahoo.com with SMTP; 06 Mar 2014 20:41:30 +0000 UTC
Message-ID: <5318DD7A.2080706@yahoo.com>
Date: Thu, 06 Mar 2014 15:41:30 -0500
From: Brian Wong <draconicpenguin1@yahoo.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>, linux-kernel@vger.kernel.org
Subject: Hyper-V Synthetic Video Frame Buffer Driver may distort top two lines
 of console
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've identified another possible bug in the Hyper-V drivers: When the 
Hyper-V Synthetic Video Frame Buffer Driver is built into the kernel, 
and the VM is paused and continued, the top two lines of the console may 
become distorted. See the image at http://imgur.com/kIExFP3.

Can someone look into it?
-- 
Brian Wong
http://www.fierydragonlord.com
