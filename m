Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbaLBWuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:50:21 -0500
Received: from mout.gmx.net ([212.227.15.15]:53542 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbaLBWuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:50:18 -0500
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v8 0/8] TPM 2.0 support
Date: Tue, 2 Dec 2014 23:55:34 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201412022355.34544.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:xzb/0LwDtHQP06QTRItgOwELBGkP8vFZvS8EEVAE8hMbrPo67RN
 VRyXi3aVBw4xnWZf56AoHkIgwO/I7No9CMTFdvsG7b0AnsYa714GzV0/jffI0fFKKfhKc/S
 LL3YkJhAqTUaObLkliCUc4RFPlsIcxb0+hGW9wL8ED2SryI1y4aJfU+z63h2vDum5V4OQeV
 sgcD7KIVUnNcwC3vN3TDQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarkko,


Am Dienstag, 2. Dezember 2014, 23:31:12 schrieb Jarkko Sakkinen:
> This patch set enables TPM2 protocol and provides drivers for FIFO and
> CRB interfaces. This patch set does not export any sysfs attributes for
> TPM 2.0 because existing sysfs attributes have three non-trivial issues:
> 


which tree are you basing your patches against?
Can you use 
https://github.com/PeterHuewe/linux-tpmdd for-james
 please?

Thanks,
Peter
