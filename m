Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3JaNIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:08:40 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4368 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498Ab3JaNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:08:39 -0400
X-Greylist: delayed 2721 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2013 09:08:38 EDT
Message-ID: <1383222136.26923.24.camel@thorin>
Subject: Re: [PATCH 1/2] tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Joe Perches <joe@perches.com>
Cc: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>,
        stable@vger.kernel.org
Date: Thu, 31 Oct 2013 13:22:16 +0100
In-Reply-To: <1383162100.9435.39.camel@joe-AO722>
References: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de>
	 <1383095144.12439.41.camel@joe-AO722>
	 <201310302035.36579.PeterHuewe@gmx.de> <1383162100.9435.39.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at 1290; Body=11 Fuz1=11
	Fuz2=11
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 SARE_SUB_6CONS_WORD subject word consists of consecutive consonants
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.2 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

On Mit, 2013-10-30 at 12:41 -0700, Joe Perches wrote:
[...]
> The arch/... assembly versions don't always
> return -1, 0, 1 so I don't think it's worth
> it to change all of those.

FWIW user-space strcmp() - e.g. as in
http://pubs.opengroup.org/onlinepubs/009695399/functions/strcmp.html but
also (glibcs) manual page- doesn't guarantee -1 or +1 either,

MfG,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

