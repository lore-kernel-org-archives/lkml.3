Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3EOGPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 02:15:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab3EOGPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 02:15:00 -0400
X-IronPort-AV: E=Sophos;i="4.87,675,1363104000"; 
   d="scan'208";a="7273608"
Message-ID: <5193275B.7070809@cn.fujitsu.com>
Date: Wed, 15 May 2013 14:12:43 +0800
From: yuxh <yuxinghai@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: virtio-blk: problem of the disk name release
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 14:13:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 14:13:45,
	Serialize complete at 2013/05/15 14:13:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

About the virtio-blk disk name,if the virtio-blk disk is detached when 
it has reference in guest, then the disk name will not be released 
forever. It seems the purpose of this is to avoid a disk error when we 
attach the disk back.
The problem by doing so is that the disk name can't be reused any more. 
I think if we can release the disk name dynamically when the reference 
no longer exist the problem will be solved. But it seems not easy to 
implement this.
Any body have a suggestion ?

Thanks,
Yu
