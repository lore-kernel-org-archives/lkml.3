Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3HBPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:16:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21681 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3HBPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:16:53 -0400
Date: Fri, 2 Aug 2013 11:16:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: alexander.deucher@amd.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Regression introduced by  31f731a drm/radeon/dpm: fix calculations
 in si_calculate_leakage_for_v_and_t_formula
Message-ID: <20130802151622.GA27748@konrad-lan.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Alex,

Your recent patch "31f731a drm/radeon/dpm: fix calculations in
si_calculate_leakage_for_v_and_t_formula" causes a build regression:

drivers/built-in.o: In function `si_calculate_leakage_for_v_and_t_formula':
/home/build/linux-linus/drivers/gpu/drm/radeon/si_dpm.c:1770: undefined
reference to `__divdi3'

Which I think is due to the misplace parentheses.

