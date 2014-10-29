Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaJ2DHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:07:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:19350 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbaJ2DG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,807,1406617200"; 
   d="scan'208";a="622497827"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: Ming Lei <ming.lei@canonical.com>
CC: "Fleming, Matt" <matt.fleming@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v1 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Thread-Topic: [PATCH v1 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Thread-Index: AQHP8TXo8HSkfE0yZkazVr6PRTgdJ5xGV2Fg
Date: Wed, 29 Oct 2014 03:04:48 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B80DB80@PGSMSX102.gar.corp.intel.com>
References: <1414131502-13886-1-git-send-email-hock.leong.kweh@intel.com>
	<1414131502-13886-2-git-send-email-hock.leong.kweh@intel.com>
 <CACVXFVOu2MyeRyyQybdAUEmp02mGHP6-kmHZ8EBx4=uJiF51LQ@mail.gmail.com>
In-Reply-To: <CACVXFVOu2MyeRyyQybdAUEmp02mGHP6-kmHZ8EBx4=uJiF51LQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9T376f0031482

> -----Original Message-----
> From: Ming Lei [mailto:ming.lei@canonical.com]
> Sent: Monday, October 27, 2014 12:00 AM
> 
> You can call fw_lookup_buf() directly, otherwise feel free to add:
> 
> Acked-by: Ming Lei <ming.lei@canonical.com>
> 

Hi Ming Lei,

The fw_lookup_buf() is defined inside the conditional preprocessor directive for CONFIG_PM_SLEEP.
Since the request_firmware_abort() may not only be used in PM_SLEEP, could I move the fw_lookup_buf()
out from the CONFIG_PM_SLEEP block if we want to call fw_lookup_buf() instead of __fw_lookup_buf()?

Thanks.


Regards,
Wilson
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
