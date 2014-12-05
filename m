Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaLEOgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:36:09 -0500
Received: from mout.gmx.net ([212.227.17.22]:65210 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaLEOgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:36:07 -0500
MIME-Version: 1.0
Message-ID: <trinity-78b59db8-b937-4ee0-989b-557fcbf612db-1417790149807@3capp-gmx-bs52>
From: "Peter Huewe" <PeterHuewe@gmx.de>
To: "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc: "Ashley Lai" <ashley@ashleylai.com>,
        "Marcel Selhorst" <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net,
        "Will Arthur" <will.c.arthur@intel.com>
Subject: Aw: Re: [PATCH v9 6/8] tpm: TPM 2.0 baseline support
Content-Type: text/plain; charset=UTF-8
Date: Fri, 5 Dec 2014 15:35:49 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20141205141303.GF6993@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1417672518-4530-7-git-send-email-jarkko.sakkinen@linux.intel.com>
 <201412050017.40668.PeterHuewe@gmx.de>, <20141205141303.GF6993@intel.com>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:gr4TABVyQkt5F8KSOT1+tPyr6BEDmKHfGY2Agwz3Ecb
 CngNlX+80mY24BgBJVlaJhp28j5Ku8qI7k6uHn8MedulmEOWgj
 rJv2klRO3jtErkNZk6ZZvluoI2XPRPsVouHi2QaPpYoJF/PrnP
 9MaWOyD7kUpZz4nu8l+tbvy9ZZrMa3Nx3SMiW+FkZshcPN4pXh
 hpPuVJmL57a6+G+pfds7aG81H+Ago1iWj7Iis9UQO7HsiSKkID
 Vh27UGk5rizkULrHgk9PTcQboXaBSACyEx4Pmw14R3Fr6tnlW1 Q9ZVrM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarkko,
  

>is it cool if I prepare a separate set of fixes for all issues
>in v9? I do not see any problem that could not be fixed without
>major structural changes.

 

to be honest - I would prefer a v10 with the fixes included, especially since there were quite a few issues/remarks.
If you already have fixes post them as patches on top of v9 so we can test, and then squash them in.




I think we are still in schedule if you do fixes over the weekend - so we hopefully have a _great_ v10 on monday/tuesday
 
I'll send out the first pull request without TPM2.0 support later this evening,
and then send out another one by next week - this should be fine.
 
The next testing slot is Sunday evening since I'm travelling myself (and don't have TPM hardware with me).
 
 
Thanks,
Peter
 
