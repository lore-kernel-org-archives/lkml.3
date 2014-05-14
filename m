Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaENVNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:13:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:39791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbaENVNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:13:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1054,1389772800"; 
   d="scan'208";a="540523399"
Message-ID: <60914.10.7.202.112.1400101964.squirrel@linux.intel.com>
In-Reply-To: <1399978733-13662-5-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
    <1399978733-13662-5-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 14 May 2014 14:12:44 -0700 (PDT)
Subject: Re: [PATCH 05/16] mfd: kempld-core: Make mfd_cell array const
From: kevin.strasser@linux.intel.com
To: "Krzysztof Kozlowski" <k.kozlowski@samsung.com>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>, "Lee Jones" <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>,
        "Kevin Strasser" <kevin.strasser@linux.intel.com>
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The kempld_devs (array of mfd_cells) can be safely made const.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kevin Strasser <kevin.strasser@linux.intel.com>

Acked-by: Kevin Strasser <kevin.strasser@linux.intel.com>

Thanks,
Kevin
