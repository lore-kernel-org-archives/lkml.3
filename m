Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbbALTtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:49:32 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:50804 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbbALTta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:49:30 -0500
Date: Mon, 12 Jan 2015 11:48:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Martin Kepplinger <martink@posteo.de>
Cc: mingo@kernel.org, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        tytso@mit.edu, maxime.coquelin@st.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bitops.h: add sign_extend8(), 16 and 64 functions
Message-ID: <20150112194846.GA18549@roeck-us.net>
References: <1421083370-24924-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421083370-24924-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54B4254A.0037,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Mon, Jan 12, 2015 at 06:22:50PM +0100, Martin Kepplinger wrote:
> This adds helper functions for sign-extending signed values of any lower
> (hardware-)given size to s8, s16 or s64 respectively, just like sign_extend32()
> for s32.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> Suggested-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
