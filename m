Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbaLDVlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:41:37 -0500
Received: from mout.gmx.net ([212.227.17.22]:58651 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbaLDVld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:41:33 -0500
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v9 8/8] tpm: TPM 2.0 FIFO Interface
Date: Thu, 4 Dec 2014 22:46:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-rc6-dirty; KDE/4.12.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net,
        Will Arthur <will.c.arthur@intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <1417672518-4530-9-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201412042246.25662.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:mTO8y8KKYVCLgMM5EQNj9F7l8kYTGxXG1qzTm02i7BBr8lnxFvZ
 He/gen5JyfHMMwPghJT1hb/JsiQtBgGJPFWlog9JCqdzkACfafT/kxjDJGxLhe7HHimYQ4j
 jNstzfiYl4RmuvjN9j8BJ2hHNtGjMzExOCbEwrNdbIK5fmKGthiRs0eaCyFovd40tFMFZSI
 5n9rg/EnZcB8WIG0fmmHg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 06:55:18 schrieb Jarkko Sakkinen:
> From: Will Arthur <will.c.arthur@intel.com>
> 
> Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
> instead of calling tpm_get_timeouts(), assign duration and timeout
> values defined in the TPM 2.0 PTP specification.
> 
> Signed-off-by: Will Arthur <will.c.arthur@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
Should we change the KConfig string?
 TPM Interface Specification 1.2 Interface
is not quite accurate anymore after applying this patch.

Thanks,
Peter
