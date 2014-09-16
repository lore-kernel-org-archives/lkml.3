Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaIPTA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:00:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51195 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaIPTA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:00:56 -0400
Subject: Re: [PATCH v3] ARM: apq8064: Add pinmux and i2c pinctrl nodes
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
X-Priority: 3 (Normal)
In-Reply-To: <1410871001.891126377@apps.rackspace.com>
Date: Tue, 16 Sep 2014 12:00:45 -0700
Cc: Andy Gross <agross@codeaurora.org>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        davidb@codeaurora.org, afaerber@suse.de, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <96034F94-3C6D-43FC-95EF-7FA705724F99@codeaurora.org>
References: <1409052645-14984-1-git-send-email-kiran.padwal@smartplayin.com>  <20140916023922.GB2386@qualcomm.com> <1410871001.891126377@apps.rackspace.com>
To: kiran.padwal@smartplayin.com
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 16, 2014, at 5:36 AM, kiran.padwal@smartplayin.com wrote:

> 
> 
> On Monday, September 15, 2014 10:39pm, "Andy Gross" <agross@codeaurora.org> said:
> 
>> On Tue, Aug 26, 2014 at 05:00:45PM +0530, Kiran Padwal wrote:
>>> This patch adds pinmux and i2c pinctrl DT node for IFC6410 board.
>>> It also adds necessary DT support for i2c eeprom which is present on
>>> IFC6410.
>>> 
>>> Tested on IFC6410 board.
>> 
>> Looks fine
> 
> Thanks for review.

Can you rebase this on:

 git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.18

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

