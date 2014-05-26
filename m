Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaEZQFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:05:41 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:33692 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaEZQFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:05:40 -0400
MIME-Version: 1.0
Date: Tue, 27 May 2014 00:05:39 +0800
Message-ID: <CAAJw_ZvxG322_y6tndUD9=1jHbrr0ZXXGhSbk538hFoQdDb8DQ@mail.gmail.com>
Subject: HCI_AUTO_OFF ... how to do that from hcitool?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ab81cbf99c881ca2b9a83682a8722fc84b2483d2
Author: Johan Hedberg <johan.hedberg@nokia.com>
Date:   Wed Dec 15 13:53:18 2010 +0200

    Bluetooth: Implement automatic setup procedure for local adapters

A new HCI_AUTO_OFF flag is added that user space needs to clear to
avoid the automatic power off


Help, how do I clear the HCI_AUTO_OFF flag using "hcitool cmd" ?

Jeff
