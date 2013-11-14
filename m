Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3KNRbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:31:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:54359 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab3KNRbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:31:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,700,1378882800"; 
   d="scan'208";a="427735546"
Message-ID: <52850A12.3090900@linux.intel.com>
Date: Thu, 14 Nov 2013 09:36:18 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.ernst@linux.intel.com,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 3/3] ipc: Added support for IPC interrupt mode
References: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com> <1384373671-12814-4-git-send-email-david.a.cohen@linux.intel.com> <20131114134842.7225c7f8@alan.etchedpixels.co.uk>
In-Reply-To: <20131114134842.7225c7f8@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

[snip]

> So I think
>
> 1. Pass the informatio upon whether IRQ mode should be used in the
> platform information and remove all the ifdeffery

I will double check with Sathya. But in case polling mode is left for
development purpose, make we can create a static variable to set irq
mode or not.

> 2. Log timeouts

Agreed.

> 3. Explain what happens on a timeout that allows you to issue further
> commands without a race - eg do you need to do any kind of reset or will
> the next command issue stall sufficiently etc ?

I'll check with Sathya.

Thanks,

David Cohen
