Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab3HGHzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:55:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38298 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3HGHzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:55:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rui Xiang <rui.xiang@huawei.com>
Cc: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <akpm@linux-foundation.org>,
        <gaofeng@cn.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <libo.chen@huawei.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
Date: Wed, 07 Aug 2013 00:55:28 -0700
In-Reply-To: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com> (Rui
	Xiang's message of "Wed, 7 Aug 2013 15:37:04 +0800")
Message-ID: <878v0evssv.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Jwj6F2xtMGGKqmkJrojXHj0cx4jhiuoI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0044]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rui Xiang <rui.xiang@huawei.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 00/11] Add namespace support for syslog
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since this still has not been addressed.  I am going to repeat Andrews
objection again.

Isn't there a better way to get iptables information out than to use
syslog.  I did not have time to follow up on that but it did appear that
someone did have a better way to get the information out.

Essentially the argument against this goes.  The kernel logging facility
is really not a particularly good tool to be using for anything other
than kernel debugging information, and there appear to be no substantial
uses for a separate syslog that should not be done in other ways.

That design objection must be addressed before merging this code can be
given serious consideration.

Eric
