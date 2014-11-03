Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaKCJnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:43:25 -0500
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:56842 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbaKCJnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:43:22 -0500
Message-ID: <54574E35.1030402@nexus-software.ie>
Date: Mon, 03 Nov 2014 09:43:17 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Raymond Tan <raymond.tan@intel.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Alvin Chen <alvin.chen@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>
Subject: Re: [PATCH 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
References: <1415000344-23575-1-git-send-email-raymond.tan@intel.com> <1415000344-23575-2-git-send-email-raymond.tan@intel.com>
In-Reply-To: <1415000344-23575-2-git-send-email-raymond.tan@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/14 07:39, Raymond Tan wrote:
> In Quark X1000, there's a single PCI device that provides both
> an I2C controller and a GPIO controller. This MFD driver will
> split the 2 devices for their respective drivers.
>
> This patch is based on Josef Ahmad's initial work for Quark enabling.

Hi Raymond.

I see support for interrupts on GPIO input has been dropped. In fact it 
doesn't appear you have any IRQ support here at all.

Could you detail the reasons why ?

Bryan
