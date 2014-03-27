Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbaC0TO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:14:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40900 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089AbaC0TO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:14:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mathieu Maret <mathieu.maret@gmail.com>,
        Jelena Bjelja <jelena.bjelja.ing@gmail.com>
References: <20140327160938.c1a4f9a5df6f93e17b55d3cd@canb.auug.org.au>
Date: Thu, 27 Mar 2014 12:14:13 -0700
In-Reply-To: <20140327160938.c1a4f9a5df6f93e17b55d3cd@canb.auug.org.au>
	(Stephen Rothwell's message of "Thu, 27 Mar 2014 16:09:38 +1100")
Message-ID: <87ob0rsbcq.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18AbHMlpKobo5atXMB2qaGZxJBJae4l9Zk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: linux-next: manual merge of the staging tree with the net-next tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Greg,
>
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/wlags49_h2/wl_netdev.c between commit 8d4ade284a41
> ("wlags49_h2: Call dev_kfree/consume_skb_any instead of dev_kfree_skb")
> from the net-next tree and commit fed3ffd8f7ef ("staging: wlags49_h2:
> reindent wl_netdev.c") (and maybe others) from the staging tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

That looks like the correct resolution.  Thanks,

Eric

