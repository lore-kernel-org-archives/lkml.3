Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbaAHU3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:29:45 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:52271 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757236AbaAHU3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:29:43 -0500
Message-ID: <1389212981.14754.21.camel@x220>
Subject: Re: [PATCH] [SCSI] advansys: change buildtime warning into runtime
 error
From: Paul Bolle <pebolle@tiscali.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 08 Jan 2014 21:29:41 +0100
In-Reply-To: <201401082115.28472.linux@rainbow-software.org>
References: <1352113082.1434.31.camel@x61.thuisdomein>
	 <1359454842.1345.40.camel@x61.thuisdomein> <1389211514.14754.10.camel@x220>
	 <201401082115.28472.linux@rainbow-software.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2014 20:29:41.0758 (UTC) FILETIME=[5C31D1E0:01CF0CB0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-08 at 21:15 +0100, Ondrej Zary wrote:
> The driver works fine with narrow boards. Please don't break working drivers 
> because of some stupid warning.

My patch changed a buildtime warning for both narrow and wide boards in
a runtime error on wide boards only. That wouldn't break the narrow
boards. (I happen to own neither a narrow nor a wide board.)

In seven years that buildtime warning has not resulted in a fix for wide
boards, has it? So at this point that warning is rather pointless.

Is anybody even using these wide boards?


Paul Bolle

