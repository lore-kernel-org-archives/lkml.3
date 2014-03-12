Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaCLRwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:52:15 -0400
Received: from nm10-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.72]:30739 "EHLO
	nm10-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755426AbaCLRwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:52:13 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Mar 2014 13:52:13 EDT
X-Yahoo-Newman-Id: 124971.55498.bm@smtp108.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iL9UAcEVM1nIbD9jAqt7MjibStbmgyU5B6jiYfUF6x2pkTf
 6vz34eL5lU4kVHP7VopqnKWpQKwoOtjcZa0uwCeA_JSDVMldE9P3T50bUMqC
 Hnxqo5VtNLzNxJXY7LNPQIvxswd3YVSbxDLrAN1_Q5i5THLWaazr5gUzC4il
 FIMYqXLZVTg5qyixPGUvkwTAoxvAYzL4.mFKTepbBXhjF7tpgZPsKp1gFiRu
 4WQCFj88kPV0NdilJY6niCxfgXHv4iXbU_SPajSfjVqmIoayWOsCjpKIoJg5
 SDVebf12XvbG7qWLZebVhaFxgVtg5bFl2LmMRRx8fiPghLU147dG_DbIl7zw
 YPs.EogLPzwLfsWijwfloiD07MaTewYXqfw7775WuqZ0scU.DcTG6pLcL_8B
 8nsIcLKyea1bk8hr7gzTz9jBH1DqFh_wvB0WI3AzQ4KBBw3jvQRzzMyz08bF
 6DNj.AmqSo_kKuKOFl.FzBNB.eynLPrPAnW0l5koaF6gYjKc7A27l3zk0Msk
 MJIkY8pK6.ZGj6n8XyiuLwNcK5kG4eVs3T1msMTOj3xR7s4mSxQudHYWt
X-Yahoo-SMTP: VtHv4LaswBDDSIzEGx1ONYC1iGcdTw--
X-Rocket-Received: from [10.210.221.5] (abertensu@200.104.16.16 with plain [63.250.193.228])
        by smtp108.mail.ne1.yahoo.com with SMTP; 12 Mar 2014 10:46:25 -0700 PDT
Message-ID: <53209D66.8000904@yahoo.com>
Date: Wed, 12 Mar 2014 14:46:14 -0300
From: Andres Bertens <abertensu@yahoo.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20140303 Thunderbird/17.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Linux 3.4.83 update: wireless card (iwlwifi) stop working
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I updated today to 3.4.83 kernel and my wireless card stop working (log 
says: iwlwifi 0000:03:00.0: Unable to initialize device).

My laptop is a Lenovo Thinkpad X230, with an Intel 6205 AGN card.

Reverting patch
     Johannes Berg <johannes.berg@intel.com>
        iwlwifi: always copy first 16 bytes of commands
makes it work again.

Regards,
Andres Bertens

PS
If of any interest, here are the related logs:

Linux mintaka 3.4.83-smp #1 SMP Wed Mar 12 13:10:44 CLST 2014 x86_64 
x86_64 x86_64 GNU/Linux

Linux-3.4.83, device not working:
--------------------------------
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc90006618000
iwlwifi 0000:03:00.0: HW Revision ID = 0x34
iwlwifi 0000:03:00.0: irq 42 for MSI/MSI-X
iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, 
REV=0xB0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
iwlwifi 0000:03:00.0: Device SKU: 0x1F0
iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlwifi 0000:03:00.0: Error sending CALIBRATION_CFG_CMD: time out after 
2000ms.
iwlwifi 0000:03:00.0: Current CMD queue read_ptr 2 write_ptr 3
iwlwifi 0000:03:00.0: Failing on timeout while stopping DMA channel 7 
[0x077f0001]
iwlwifi 0000:03:00.0: Failed to run INIT ucode: -110
iwlwifi 0000:03:00.0: Unable to initialize device.


Linux-3.4.83, patch remove, device working:
-------------------------------------------
iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base = ffffc9000672c000
iwlwifi 0000:03:00.0: HW Revision ID = 0x34
iwlwifi 0000:03:00.0: irq 42 for MSI/MSI-X
iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, 
REV=0xB0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: device EEPROM VER=0x715, CALIB=0x6
iwlwifi 0000:03:00.0: Device SKU: 0x1F0
iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
