Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbbALTx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:53:58 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51752 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbbALTx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:53:56 -0500
Date: Mon, 12 Jan 2015 11:53:17 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Martin Kepplinger <martink@posteo.de>
Cc: mingo@kernel.org, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        tytso@mit.edu, maxime.coquelin@st.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] hwmon: jc42: use bitops' sign_extend16
Message-ID: <20150112195317.GB18549@roeck-us.net>
References: <1421083370-24924-1-git-send-email-martink@posteo.de>
 <1421083700-25258-1-git-send-email-martink@posteo.de>
 <1421083700-25258-4-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421083700-25258-4-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.54B42654.014E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 06:28:20PM +0100, Martin Kepplinger wrote:
> Example change, using new sign_extend functions.

No need to drop the Signed-off: line; it only means that I can not take
the patch even if I want to. Also, if the patch itself is final, no need
to state that it is an example in the description. Instead, use an
introductory mail (RFC PATCH 0/x] to explain the background.

Otherwise looks good; feel free to add

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

to the next version.

Thanks,
Guenter
