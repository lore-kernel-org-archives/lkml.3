Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab3ILDin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:38:43 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53128 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3ILDim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:38:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, kay@vrfy.org,
        netdev@vger.kernel.org, lizefan@huawei.com
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
	<20130912031912.GA9773@kroah.com>
Date: Wed, 11 Sep 2013 20:38:32 -0700
In-Reply-To: <20130912031912.GA9773@kroah.com> (Greg KH's message of "Wed, 11
	Sep 2013 20:19:12 -0700")
Message-ID: <87eh8u4slj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ijlCN897JmIj/CXv6ZpeZlPS8ahkQUDY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0064]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCHSET] sysfs: disentangle kobject namespace handling from sysfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Wed, Sep 11, 2013 at 10:29:02PM -0400, Tejun Heo wrote:
>> Hello,
>> 
>> I'll send out multiple patchsets to separate out sysfs from driver
>> core and kobject.  The eventual goal is making sysfs modular enough so
>> that cgroup can replace its nightmarish cgroupfs implementation which
>> repeated and worsened all the past mistakes of sysfs.  This patchset
>> is first of the effort and separates out kobject namespace handling
>> from sysfs.
>> 
>> I never really understood why namespace support was added the way it
>> was added.
>
> I just took the patches and didn't ask questions :)

Greg you don't get to play dumb you asked questions and required most of
the current strucuture of the code.

The code is convoluted by your request.

Eric
