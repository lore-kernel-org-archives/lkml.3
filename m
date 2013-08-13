Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab3HML2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:28:55 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:34213 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab3HML2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:28:54 -0400
Message-ID: <520A1871.4000501@gmail.com>
Date: Tue, 13 Aug 2013 13:28:49 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/9] ARM: dove: add PCIe controllers to SoC DT
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376333215-12885-8-git-send-email-sebastian.hesselbarth@gmail.com> <20130812200452.GW25111@titan.lakedaemon.net>
In-Reply-To: <20130812200452.GW25111@titan.lakedaemon.net>
Content-Type: multipart/mixed;
 boundary="------------020806050301020800090405"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020806050301020800090405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/12/13 22:04, Jason Cooper wrote:
> On Mon, Aug 12, 2013 at 08:46:53PM +0200, Sebastian Hesselbarth wrote:
>> This adds a node for the pcie controllers found on Dove SoCs to the
>> SoC DT include.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Jason Cooper <jason@lakedaemon.net>
>> Cc: Andrew Lunn <andrew@lunn.ch>
>> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> ---
>>   arch/arm/boot/dts/dove.dtsi |   54 +++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 54 insertions(+)
>
> patches 7-9 applied to mvebu/dove_mbus since the dependencies are
> cleaner that way.

Jason,

I will have to slightly modify the reset-gpio property names and that
requires a fixup patch for patch 8. Can you still squash it or do you
need a proper patch?

Sebastian

---



--------------020806050301020800090405
Content-Type: text/x-patch;
 name="d3plug-dts.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="d3plug-dts.diff"

diff --git a/arch/arm/boot/dts/dove-d3plug.dts b/arch/arm/boot/dts/dove-d3plug.dts
index ead90eb..f5f59bb 100644
--- a/arch/arm/boot/dts/dove-d3plug.dts
+++ b/arch/arm/boot/dts/dove-d3plug.dts
@@ -91,7 +91,7 @@
 	pcie-port@0 {
 		status = "okay";
 		reset-gpios = <&gpio0 26 1>;
-		reset-delay-ms = <20>;
+		reset-delay-us = <20000>;
 		pinctrl-0 = <&pmx_camera_gpio>;
 		pinctrl-names = "default";
 	};

--------------020806050301020800090405--
