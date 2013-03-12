Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937Ab3CLXEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:04:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33078 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804Ab3CLXEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:04:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Larry Baker <baker@usgs.gov>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        David Miller <davem@redhat.com>
References: <20130312223245.109098379@linuxfoundation.org>
	<20130312223247.449652622@linuxfoundation.org>
	<B401117D-23F6-4911-8D72-344EE1A022F6@usgs.gov>
Date: Tue, 12 Mar 2013 16:04:03 -0700
In-Reply-To: <B401117D-23F6-4911-8D72-344EE1A022F6@usgs.gov> (Larry Baker's
	message of "Tue, 12 Mar 2013 15:52:19 -0700")
Message-ID: <87r4jkjk4c.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1/MLGE8I/4kwYe7Ydy9uwswBDqc53buXtg=
X-SA-Exim-Connect-IP: 208.54.5.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Larry Baker <baker@usgs.gov>
X-Spam-Relay-Country: 
Subject: Re: [ 20/21] decnet: Fix disappearing sysctl entries
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Baker <baker@usgs.gov> writes:

> Greg,
>
> Will there also be a 2.6-stable patch (Eric's first submission)?  My CentOS 6.3
> systems still use 2.6 kernels.

Larry what is in CentOS is for the CentOS maintainers to determine.
Last I checked they followed RHEL and RHEL seems to have so little
interest in decnet that the module isn't even built.

Pushing it to the patch to -stable makes the patch available to them if
they want to pick up the bugfix.

Beyond that if you look at
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?id=refs/tags/v2.6.32.60
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/log/?id=refs/tags/v2.6.34.14

You can see that it is Willy Tarreau that makes releases for 2.6.32.y
and it is Paul Gortmaker that make releases releases for 2.6.34.y

So I don't expect Greg KH has anything to do with those kernels anymore.

Eric
