Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbaJHBDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 21:03:35 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:37579 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755597AbaJHBDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 21:03:21 -0400
Message-ID: <54348D56.20708@nexus-software.ie>
Date: Wed, 08 Oct 2014 02:03:18 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Weike Chen <alvin.chen@intel.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Raymond Tan <raymond.tan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 2/2 v2] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
References: <1412000548-9908-1-git-send-email-alvin.chen@intel.com> <1412000548-9908-3-git-send-email-alvin.chen@intel.com>
In-Reply-To: <1412000548-9908-3-git-send-email-alvin.chen@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/14 15:22, Weike Chen wrote:
> +		.num_chipselect = 4,

How is this right ?

There's only one physical chip-select line per SPI master...

It's a 1:1 mapping.

Best,
Bryan
