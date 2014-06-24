Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaFXB26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 21:28:58 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:39880 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFXB25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 21:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140623185631.GK19730@lukather>
References: <1403275973-24259-1-git-send-email-wens@csie.org>
 <1403275973-24259-5-git-send-email-wens@csie.org> <20140623185631.GK19730@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 24 Jun 2014 09:28:36 +0800
X-Google-Sender-Auth: HXWfo5Fddl9-8YmxV02-6xnzUBs
Message-ID: <CAGb2v67_6v-6a69eia_7eq+bVNNnYf6ngdF8GDJeeyGub-fiDg@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ARM: sun8i: dt: Add Ippo-q8h v5 support
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 2:56 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Fri, Jun 20, 2014 at 10:52:53PM +0800, Chen-Yu Tsai wrote:
>> The Ippo-q8h is a tablet circuit board commonly found in cheap Android
>> tablets with A23 SoCs. There are at least 2 versions of the board, with
>> different peripherals, such as WiFi chips.
>>
>> Common features among these tablets include 512 MB DRAM, NAND, MMC, LCD,
>> capacitive touchscreen, accelerometer, 1 or 2 camera sensors, USB OTG,
>> microphone and speaker.
>>
>> v5 of these board designs has a ESP8089 WiFi chip (not supported)
>> connected to mmc1. This patch adds very basic support.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>
> Fixed the whitespace warning and applied.

Trailing newline, got it.

Thanks!
ChenYu
