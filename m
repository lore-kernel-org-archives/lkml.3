Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaGPVbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:31:37 -0400
Received: from 203-174-129-26.bri.static-ipl.aapt.com.au ([203.174.129.26]:32908
	"EHLO bne.vrt.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbaGPVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:31:31 -0400
From: Stuart Longland <stuartl@vrt.com.au>
To: Roman Fietze <roman.fietze@telemotive.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [REVISED PATCH] drivers/rtc/rtc-isl12022.c: Device tree support
Date: Thu, 17 Jul 2014 07:31:00 +1000
Message-Id: <1405546262-4333-1-git-send-email-stuartl@vrt.com.au>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <20140716085904.GA26951@leverpostej>
References: <20140716085904.GA26951@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches are the revised set, incorporating Mark Rutland's
feedback.

