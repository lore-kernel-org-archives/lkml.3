Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaERPT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:19:58 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34726 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaERPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:19:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 00/28] staging: rtl8188eu: Remove unnecessary functions.
Date: Sun, 18 May 2014 20:48:53 +0530
Message-Id: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patches remove functions which are unused or have empty
definition.

navin patidar (28):
  staging: rtl8188eu: Remove function with empty definition
    _InitBeaconMaxError().
  staging: rtl8188eu: Remove function with empty definition
    _InitOperationMode()
  staging: rtl8188eu: Remove function with empty definition
    _ps_open_RF()
  staging: rtl8188eu: Remove unused function _ps_close_RF()
  staging: rtl8188eu: Remove unused function rtl8188eu_ps_func()
  staging:rtl8188eu:Remove funtion Hal_CustomizeByCustomerID_8188EU()
  staging: rtl8188eu: Remove unused function
    rtl8188e_PHY_ConfigRFWithParaFile()
  staging: rtl8188eu: Remove unused function
    rtl8192c_PHY_GetHWRegOriginalValue()
  staging: rtl8188eu: Remove unused function
    PHY_UpdateTxPowerDbm8188E()
  staging:rtl8188eu: Remove unused function phy_DbmToTxPwrIdx()
  staging: rtl8188eu: Remove unused funtion PHY_GetTxPowerLevel8188E()
  staging: rtl8188eu: Remove unused funtion phy_TxPwrIdxToDbm()
  staging: rtl8188eu: Remove unused funtion phy_TxPwrIdxToDbm()
  staging: rtl8188eu: Remove unused structure rf_shadow
  staging: rtl8188eu: Remove unused function rtl8188e_RF_ChangeTxPath()
  staging: rtl8188eu: Remove unused function odm_DIGbyRSSI_LPS()
  staging: rtl8188eu: Remove function odm_DynamicBBPowerSaving()
  staging: rtl8188eu: Remove unused function
    odm_DynamicBBPowerSavingInit()
  staging:rtl8188eu: Remove unused function iodm_1R_CCA()
  staging: rtl8188eu: Remove unused function
    odm_RefreshRateAdaptiveMaskMP()
  staging: rtl8188eu: Remove unused function
    odm_RefreshRateAdaptiveMaskAPADSL()
  staging: rtl8188eu: Remove unused funtion odm_DynamicTxPowerNIC()
  staging: rtl8188eu: Remove unused function
    odm_SwAntDivChkAntSwitchCallback()
  staging: rtl8188eu: Remove unused function ConvertTo_dB()
  staging: rtl8188eu: Remove function with empty defination
    ODM_CheckPowerStatus()
  staging: rtl8188eu: Remove unused function DM_DIG_LowerBound_88E()
  staging: rtl8188eu: Remove unused function
    ODM_DynamicPrimaryCCA_DupRTS()
  staging: rtl8188eu:Remove function with empty defination
    odm_DynamicPrimaryCCA()

 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |   14 --
 drivers/staging/rtl8188eu/hal/odm.c                |  159 ---------------
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c       |   24 ---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |  208 --------------------
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |   45 -----
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |   40 ----
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    1 -
 drivers/staging/rtl8188eu/include/odm_RTL8188E.h   |    2 -
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |    1 -
 9 files changed, 494 deletions(-)

--
1.7.10.4

