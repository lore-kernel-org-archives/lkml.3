Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab3HFG4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 02:56:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab3HFG4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 02:56:09 -0400
Date: Tue, 6 Aug 2013 08:54:43 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [3.10 regression] mei endless recursion
Message-ID: <20130806065442.GA3509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We have a bug report when system fail to boot on 3.10 . It happens due to
problem in mei which do endless calls:

mei_reset -> mei_hbm_start_req -> mei_reset -> mei_hbm_start_req -> ...

It did not happen on 3.9.

Report is here:
https://bugzilla.redhat.com/show_bug.cgi?id=991571

Stanislaw
