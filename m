Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaFDJeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:34:00 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:55875 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734AbaFDJd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:33:58 -0400
Message-ID: <1401874435.14072.17.camel@x220>
Subject: ARC:  ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
From: Paul Bolle <pebolle@tiscali.nl>
To: Vineet Gupta <vgupta@synopsys.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 04 Jun 2014 11:33:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jun 2014 09:33:56.0256 (UTC) FILETIME=[1B2BEA00:01CF7FD8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

Linux-next included commit c00bfd974fb0 ("ARC: [arcfpga] Get rid of
legacy BVCI latency unit support") in next-20140604. It removes the
Kconfig symbol ARC_HAS_BVCI_LAT_UNIT. And that symbol's entry is the
only place were the symbols ARC_BOARD_ANGEL4 and ARC_BOARD_ML509 are
currently used. So it follows that the entries for ARC_BOARD_ANGEL4 and
ARC_BOARD_ML509 could be removed too.

If that's correct: is the trivial patch to remove the Kconfig entries
for ARC_BOARD_ANGEL4 and ARC_BOARD_ML509 queued somewhere?


Paul Bolle

