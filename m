Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbaDXNgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:36:46 -0400
Received: from plane.gmane.org ([80.91.229.3]:50285 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbaDXNgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:36:44 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?Rapha=EBl_Bauduin?= <rblists@gmail.com>
Subject: LSI Fusion mpt driver queue full message really harmless?
Date: Thu, 24 Apr 2014 15:36:30 +0200
Message-ID: <ljb40v$gq8$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 217.64.254.218.mactelecom.net
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm sending this mail here as a last resort [1], hoping someone can help me, as on recent kernels (tested 3.2, 3.11, 3.12, 3.13, 3.14), I get 
this message from the LSI Fusion mpt driver for the disk containing the root partition of the server:
  strange observation, the queue depth is (64) meanwhile fw queue depth (65)

Seems that handling the queue full event (http://lxr.oss.org.cn/source/drivers/message/fusion/mptsas.c#L4091 ) was added in 2.6.31, but running 
2.6.32.61 I do not have this message.

I've seen one discussion on the web of this problem (but related to the 2.6.32 kernel) where it was said that this message is harmless, but I'd 
like a confirmation of this. Can I be sure there won't be any data loss related to this message?

System information are available in the ticket I opened at https://bugzilla.kernel.org/show_bug.cgi?id=74011
This is happening for 2 similar servers, one of which seeing very low load.

Thanks in advance for your help!

Raphaël

[1] having contacted the linux-scsi ml, the LSI driver devs, opened a bug report and contacted one individual LSI dev before, but getting no 
response.

