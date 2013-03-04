Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab3CDWoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:44:38 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45069 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3CDWoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:44:37 -0500
MIME-Version: 1.0
In-Reply-To: <CANeMGR5a78oq63N4Fr9x0kEQue3GiXeMX7L9Om5-AqUUxdzEPQ@mail.gmail.com>
References: <CANeMGR5a78oq63N4Fr9x0kEQue3GiXeMX7L9Om5-AqUUxdzEPQ@mail.gmail.com>
From: Guan Xin <guanx.bac@gmail.com>
Date: Mon, 4 Mar 2013 23:43:55 +0100
Message-ID: <CANeMGR7fTCV7tgnOXj20AT9RA4MxXi6JdhWv-TcspjzMRYauhQ@mail.gmail.com>
Subject: Re: [Bug] Various abnormal WiFi behaviors with Linux 3.8 on arm/imx23
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 1:44 AM, Guan Xin <guanx.bac@gmail.com> wrote:
> Hello,
>
> I have just moved from Linux 3.7.x to Linux 3.8.x because 3.7.x is
> EOL-ed. On an iMX233-OLinuXino-MICRO with USB WiFi adapters I got the
> following problems which were never present in Linux 3.7.x.
> ... ...

Today I upgraded from 3.8.1 to 3.8.2 and started to see some errors in dmesg:

[   35.160000] rtl8192cu: Chip version 0x11
[   35.160000] rtl8192cu:_rtl92cu_read_adapter_info():<0-0> EEPROM
ID(0xffff) is invalid!!
[   35.160000] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[   35.160000] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
[   35.170000] usbcore: registered new interface driver rtl8192cu
[   35.240000] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   35.240000] rtlwifi: wireless switch is on
... ...
[   89.900000] rtl8192cu: MAC auto ON okay!
[   89.980000] rtl8192cu:rtl92c_llt_write():<0-0> Failed to polling
write LLT done at address 0! _LLT_OP_VALUE(3)
[   89.980000] rtl8192cu: ===> rtl92c_init_llt_table #1 fail
[   89.980000] rtl8192cu:_rtl92cu_init_mac():<0-0> Failed to init LLT Table!
[   89.980000] rtl8192cu:rtl92cu_hw_init():<0-0> init mac failed!


Guan
