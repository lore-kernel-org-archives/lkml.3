Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaIAIWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:22:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44190 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaIAIWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:22:10 -0400
MIME-Version: 1.0
Date: Mon, 1 Sep 2014 16:22:07 +0800
Message-ID: <CACVXFVN6f3Og+D_70M+4j_qhGNsryJWzTJK8G+rY0sxXweMqQg@mail.gmail.com>
Subject: [Bug] 3.16 fwdownload failure on Marvell 88SE9125 sata controller
From: Ming Lei <ming.lei@canonical.com>
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gaurav <gspatel@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

When we use hdparm to download firmware on system with
Marvell 88SE9125 SATA controller, it returns failure always
and it has been observed in several systems:

#hdparm --fwdownload-mode7 fw.bin
--yes-i-kno-what-i-am-doing --please-destroy-my-drive /dev/sda

/dev/sda:
fwdownload: xfer_mode=7 min=1 max=65535 size=699392
FAILED: Input/output error


Thanks,
--
Ming Lei
