Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbbAOPDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:03:17 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39745 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbbAOPDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:03:15 -0500
From: "Dov Levenglick" <dovl@codeaurora.org>
To: "'Yaniv Gardi'" <ygardi@codeaurora.org>,
        <James.Bottomley@HansenPartnership.com>, <hch@infradead.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <santoshsy@gmail.com>,
        <linux-scsi-owner@vger.kernel.org>, <subhashj@codeaurora.org>,
        <noag@codeaurora.org>, <draviv@codeaurora.org>
References: <1421332359-31785-1-git-send-email-ygardi@codeaurora.org>
In-Reply-To: <1421332359-31785-1-git-send-email-ygardi@codeaurora.org>
Subject: RE: [PATCH v7 0/5] phy: qcom-ufs: add support for QUALCOMM
Date: Thu, 15 Jan 2015 17:03:08 +0200
Message-ID: <003a01d030d4$6216b640$264422c0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLyECbudUg3Mezm9c1ofuarb4QT25p9hfzg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Dov Levenglick <dovl@codeaurora.org>


Dov Levenglick

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a
Linux Foundation Collaborative Project

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Yaniv Gardi
> Sent: Thursday, January 15, 2015 4:33 PM
> To: James.Bottomley@HansenPartnership.com; hch@infradead.org
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; linux-arm-
> msm@vger.kernel.org; santoshsy@gmail.com; linux-scsi-
> owner@vger.kernel.org; subhashj@codeaurora.org;
> ygardi@codeaurora.org; noag@codeaurora.org; draviv@codeaurora.org
> Subject: [PATCH v7 0/5] phy: qcom-ufs: add support for QUALCOMM
> 
> Changes from V6:
> - change#1 in the V6 series: 0001-phy-qcom-ufs-add-support-for-20nm-phy
>   has been divided into 2 patches:
>   A: phy: qcom-ufs: add support for QUALCOMM Technologies UFS PHY
> drivers
>   B: phy: qcom-ufs: add support for 20nm phy
>   in order to seperate the common code of the Qualcomm Technologies
>   UFS PHYs and the specific UFS PHYs that will be added.
> 
> Yaniv Gardi (5):
>   phy: qcom-ufs: add support for QUALCOMM Technologies UFS PHY drivers
>   phy: qcom-ufs: add support for 20nm phy
>   scsi: ufs-qcom: add support for Qualcomm Technologies Inc platforms
>   phy: qcom-ufs: add support for 14nm phy
>   scsi: ufs-qcom-ice: add Inline Crypto Engine (ICE) support for UFS
> 
>  drivers/phy/Kconfig                 |    7 +
>  drivers/phy/Makefile                |    3 +
>  drivers/phy/phy-qcom-ufs-i.h        |  159 ++++++
>  drivers/phy/phy-qcom-ufs-qmp-14nm.c |  201 +++++++
>  drivers/phy/phy-qcom-ufs-qmp-14nm.h |  177 ++++++
>  drivers/phy/phy-qcom-ufs-qmp-20nm.c |  257 +++++++++
>  drivers/phy/phy-qcom-ufs-qmp-20nm.h |  235 ++++++++
>  drivers/phy/phy-qcom-ufs.c          |  745 ++++++++++++++++++++++++
>  drivers/scsi/ufs/Kconfig            |   25 +
>  drivers/scsi/ufs/Makefile           |    2 +
>  drivers/scsi/ufs/ufs-qcom-ice.c     |  520 +++++++++++++++++
>  drivers/scsi/ufs/ufs-qcom-ice.h     |  113 ++++
>  drivers/scsi/ufs/ufs-qcom.c         | 1058
> +++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-qcom.h         |  195 +++++++
>  include/linux/phy/phy-qcom-ufs.h    |   59 ++
>  15 files changed, 3756 insertions(+)
>  create mode 100644 drivers/phy/phy-qcom-ufs-i.h
>  create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.c
>  create mode 100644 drivers/phy/phy-qcom-ufs-qmp-14nm.h
>  create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.c
>  create mode 100644 drivers/phy/phy-qcom-ufs-qmp-20nm.h
>  create mode 100644 drivers/phy/phy-qcom-ufs.c
>  create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c
>  create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.h
>  create mode 100644 drivers/scsi/ufs/ufs-qcom.c
>  create mode 100644 drivers/scsi/ufs/ufs-qcom.h
>  create mode 100644 include/linux/phy/phy-qcom-ufs.h
> 
> --
> 1.8.5.2
> 
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
> member of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

