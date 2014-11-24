Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278AbaKXWeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:34:12 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65062 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaKXWeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:09 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH v2 00/14] of: DT Overlay patches to be merged
Date: Mon, 24 Nov 2014 22:33:28 +0000
Message-Id: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second time I've posted the Devicetree Overlay patch series
with the intention of merging for v3.19. I'm reposting the entire series
again because I've done some mild rework and reordered a number of
things to make a bit more sense. Most notable changes are:
patch 04/14: Change the return value of of_reconfig_get_state_change() to an
             enum
patch 05/14: (new) Create empty stubs so the notifiers can be simpler
patch 07/14: (new) Rework notifiers to always use a structure for
             notifier data
patch 11/14 through 14/14: Add i2c and spi support

Mark and Wolfram, I've cc'd you on this series even though you'll only
be interested in 11,12 and 13,14 respectively. If you're okay with these
patches then I'd like to merge them through my tree to keep the
dependencies together.

Thanks,
g.

