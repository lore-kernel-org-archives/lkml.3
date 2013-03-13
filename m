Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab3CMUFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:05:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51430 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3CMUFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:05:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Larry Baker <baker@usgs.gov>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        David Miller <davem@redhat.com>
References: <20130312223245.109098379@linuxfoundation.org>
	<20130312223247.449652622@linuxfoundation.org>
	<B401117D-23F6-4911-8D72-344EE1A022F6@usgs.gov>
	<87r4jkjk4c.fsf@xmission.com>
	<3EDA829E-3898-4626-9C17-CCE31E8C0554@usgs.gov>
Date: Wed, 13 Mar 2013 13:05:34 -0700
In-Reply-To: <3EDA829E-3898-4626-9C17-CCE31E8C0554@usgs.gov> (Larry Baker's
	message of "Wed, 13 Mar 2013 12:35:36 -0700")
Message-ID: <87zjy7cbg1.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/iadvrbR+JyZpEw+9LUJ7mo74WrJZHBfw=
X-SA-Exim-Connect-IP: 208.54.5.253
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
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

> I gather then that the long term kernels shown at https://www.kernel.org/ might eventually get updated if Willy Tarreau and Paul Gortmaker subscribe to the stable@vger.kernel.org list and decide to apply Eric's patches to the mainline stable 2.6 kernels.  Otherwise (or, in addition?), I would have to file bug reports to, e.g., CentOS, for them to update their distributions.  I can refer CentOS to http://www.spinics.net/lists/netdev/msg226123.html for that.  In the mean time, do I have your permission Eric to post your patches to the Linux DECnet web site?

Of course.  The patch is covered under the GPL license which gives
anyone the right to redistribute it.

Eric
