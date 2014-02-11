Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaBKP3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:29:32 -0500
Received: from 213083164162.static.sonofon.dk ([213.83.164.162]:33157 "EHLO
	HORWDSPRD01.spectralink.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751735AbaBKP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:29:29 -0500
From: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
To: richardcochran@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH v2 0/2] dp83640: Get pin and master/slave configuration from DT
Date: Tue, 11 Feb 2014 16:29:20 +0100
Message-Id: <1392132562-23644-1-git-send-email-stefan.sorensen@spectralink.com>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Feb 2014 15:29:26.0416 (UTC) FILETIME=[0C424900:01CF273E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add DT configuration to the DP83640 PHY driver and makes
the configuration of periodic output pins dynamic.

Changes since v1:
 - Add bindings documentation
 - Keep module parameters
 - Rename gpio->pin
 - Split patch into DT part and dynamic periodic output support

Stefan


Stefan Sørensen (2):
  dp83640: Support a configurable number of periodic outputs
  dp83640: Get pin and master/slave configuration from DT

 Documentation/devicetree/bindings/net/dp83640.txt |  29 +++
 drivers/net/phy/dp83640.c                         | 205 +++++++++++++++-------
 2 files changed, 175 insertions(+), 59 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dp83640.txt

-- 
1.8.5.3

