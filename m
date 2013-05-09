Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab3EICAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 22:00:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29514 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab3EICAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 22:00:33 -0400
X-IronPort-AV: E=Sophos;i="4.87,638,1363104000"; 
   d="scan'208";a="7221006"
Message-ID: <518AF840.7080405@cn.fujitsu.com>
Date: Thu, 09 May 2013 09:13:36 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH RFC 00/48] Add namespace support for audit
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com> <1368032112.2139.0.camel@localhost>
In-Reply-To: <1368032112.2139.0.camel@localhost>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/09 09:10:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/09 09:10:51,
	Serialize complete at 2013/05/09 09:10:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 12:55 AM, Eric Paris wrote:
> What kernel are these patches against?
> 

This patchset is based on linus's tree.
The last commit is d7ab7302f970a254997687a1cdede421a5635c68
(Merge tag 'mfd-3.10-1' of git://git.kernel.org/pub/scm/linux/kernel/git/same)

Thanks
Gao
