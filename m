Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab3KLVor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:44:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:60289 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab3KLVoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:44:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434155506"
Message-ID: <5282A255.5090904@linux.intel.com>
Date: Tue, 12 Nov 2013 13:49:09 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: cjb@laptop.org
CC: adrian.hunter@intel.com, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuanxiao.dong@intel.com
Subject: Re: [RFC/PATCH 0/2] mmc: sdhci: Workaround Intel Merrifield issue
 for HS200
References: <1383069507-27574-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1383069507-27574-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 10:58 AM, David Cohen wrote:
> Hi,
>
> SDHCI used to work well on Intel Merrifield until this patch was applied:
>
> commit 156e14b126ffb6f040bc6f1aff3c51077e42a744
> Author: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
> Date:   Wed Jun 12 08:16:38 2013 +0200
>
>      mmc: sdhci: fix caps2 for HS200
>
>      Although the HC supports HS200 (eMMC) the caps2 are always zero; this
>      means there's no way to use the super speed mode (when init the card).
>
>      If the HC support SDR104, for SD3.0, so it also supports HS200 for eMMC
>      and this patch just sets the MMC_CAP2_HS200 in the host caps2 field.
>
> Looks like there is a hw issue with unknown root cause so far.
>
> Is it acceptable to have the quirk I'm proposing to workaround the issue?

Ping. Any comments here?

Br, David Cohen
