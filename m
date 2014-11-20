Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbaKTB4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 20:56:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:41364 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbaKTB4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 20:56:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,420,1413270000"; 
   d="scan'208";a="634913580"
Message-ID: <546D49CC.3030806@intel.com>
Date: Thu, 20 Nov 2014 09:54:20 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: rjw@rjwysocki.net, lenb@kernel.org, robert.moore@intel.com,
        lv.zheng@intel.com, shigorin@gmail.com, adamw@happyassassin.net,
        jan.brummer@tabos.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devel@acpica.org
Subject: Re: [PATCH] ACPI: Add _DEP(Operation Region Dependencies) support
 to fix battery issue on the Asus T100TA
References: <1416410441-14425-1-git-send-email-tianyu.lan@intel.com> <20141119160547.GA8557@katana>
In-Reply-To: <20141119160547.GA8557@katana>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年11月20日 00:05, Wolfram Sang wrote:
> As long as the I2C related changes are that minimal:
> 
> Acked-by: Wolfram Sang <wsa@the-dreams.de> for the I2C part
> 

Thank you!

-- 
Best regards
Tianyu Lan
