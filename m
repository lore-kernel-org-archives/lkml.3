Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3CJLcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:32:47 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:42846 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab3CJLcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:32:45 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-18.arcor-online.net 43F383DC32E
Subject: [PATCH 0/5] HID: roccat: Support for new devices and further code
 removals
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Mar 2013 12:32:40 +0100
Message-ID: <1362915160.2769.165.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for two new devices.

While more functionality gets moved to userland the code for older modules
gets again stripped down further to minimum functionality.

The userland-tools supporting these changes are up for download nearly a
month now.

