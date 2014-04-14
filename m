Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaDNKsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:48:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbaDNKsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:48:05 -0400
Date: Mon, 14 Apr 2014 12:48:02 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] driver core: Clean up dev_get/set_drvdata
Message-ID: <20140414124802.2859439e@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a proposal to revert most of commit b4028437. This
would solve a memory leak and also allow to simplify and ultimately
inline again functions dev_get_drvdata and dev_set_drvdata for smaller
footprint and improved performance.

[PATCH 1/5] driver core: Move driver_data back to struct device
[PATCH 2/5] driver core: dev_set_drvdata can no longer fail
[PATCH 3/5] driver core: dev_set_drvdata returns void
[PATCH 4/5] driver core: dev_get_drvdata: Don't check for NULL dev
[PATCH 5/5] driver core: Inline dev_set/get_drvdata

-- 
Jean Delvare
SUSE L3 Support
