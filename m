Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3H1TVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:21:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49562 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3H1TVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:21:19 -0400
Subject: Re: [PATCH v3 0/2] Document msm_serial bindings and support newer uartdms
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20130828191952.GC19754@codeaurora.org>
Date: Wed, 28 Aug 2013 14:21:21 -0500
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <795F01B3-6225-4FBB-AB8B-ECCDF5703AA7@codeaurora.org>
References: <1377648764-23453-1-git-send-email-sboyd@codeaurora.org> <89FFB174-E076-4309-BE9C-7DB24B31599F@codeaurora.org> <20130828191952.GC19754@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28, 2013, at 2:19 PM, Stephen Boyd wrote:

> On 08/28, Kumar Gala wrote:
>> 
>> On Aug 27, 2013, at 7:12 PM, Stephen Boyd wrote:
>> 
>>> This patchset aligns the msm_serial driver more with downstream usage and
>>> updates the driver's DT bindings.
>>> 
>>> Changes since v2:
>>> * Fixed up DT review comments
>>> * Dropped patches that were picked up in tty tree
>>> 
>>> Changes since v1:
>>> * Dropped _clk postfix from {core,iface}_clk
>>> * Split DT binding into two files
>>> * Renamed DT binding files to match compatible strings
>>> * Fixed up DT review comments
>>> * Added new patch 5/5 (more than 1 char for UARTDM)
>>> 
>>> Stephen Boyd (2):
>>> devicetree: serial: Document msm_serial bindings
>>> ARM: dts: msm: Update uartdm compatible strings
>>> 
>>> .../devicetree/bindings/tty/serial/msm_serial.txt  | 27 -----------
>>> .../bindings/tty/serial/qcom,msm-uart.txt          | 25 ++++++++++
>>> .../bindings/tty/serial/qcom,msm-uartdm.txt        | 53 ++++++++++++++++++++++
>>> arch/arm/boot/dts/msm8660-surf.dts                 |  2 +-
>>> arch/arm/boot/dts/msm8960-cdp.dts                  |  2 +-
>>> 5 files changed, 80 insertions(+), 29 deletions(-)
>>> delete mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial.txt
>>> create mode 100644 Documentation/devicetree/bindings/tty/serial/qcom,msm-uart.txt
>>> create mode 100644 Documentation/devicetree/bindings/tty/serial/qcom,msm-uartdm.txt
>> 
>> We are going with bindings/serial as one location, can you update this so the bindings are in bindings/serial/qcom...
>> 
> 
> Ok I can move it. Do I have your ack on patch 2?


Yes, I thought I sent it.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

