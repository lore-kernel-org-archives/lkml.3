Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab3JODzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:55:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:45319 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab3JODzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:55:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,496,1378882800"; 
   d="scan'208";a="392984410"
Message-ID: <52278.10.7.201.52.1381809337.squirrel@linux.intel.com>
In-Reply-To: <1378208904.11730.2.camel@x230>
References: <cover.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
    <871d1b965914d6c90e698aa67827854e748f18e1.1374547036.git.sathyanarayanan.kuppuswamy@linux.intel.com>
    <1378208904.11730.2.camel@x230>
Date: Mon, 14 Oct 2013 20:55:37 -0700 (PDT)
Subject: Re: [PATCH v1 3/3] ipc: Add support for default interrupt mode
From: sathyanarayanan.kuppuswamy@linux.intel.com
To: "Matthew Garrett" <matthew.garrett@nebula.com>
Cc: "Kuppuswamy Sathyanarayanan" 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2013-07-22 at 19:48 -0700, Kuppuswamy Sathyanarayanan wrote:
>> Added intel scu ipc access mode config option.
>>
>> Also, This patch adds support to enable ipc command interrupt
>> mode by default. This functionality is enabled by following
>> config option.
>>
>> CONFIG_INTEL_SCU_IPC_INTR_MODE=y
>
> Can you document this in the help text? It's unclear whether people
> should enable this option or not.

Thanks for the review. I will update the help content in my next patchset.

> --
> Matthew Garrett <matthew.garrett@nebula.com>
>

--
Sathyanarayanan Kuppuswamy
