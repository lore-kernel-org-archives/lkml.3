Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaIBUNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:13:14 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:36807 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754404AbaIBUNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:13:13 -0400
From: Andy King <acking@vmware.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc: davem@davemloft.net, pv-drivers@vmware.com,
        penguin-kernel@I-love.SAKURA.ne.jp, sergei.shtylyov@cogentembedded.com
Subject: 
Date: Tue,  2 Sep 2014 13:13:43 -0700
Message-Id: <1409688824-32619-1-git-send-email-acking@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version addresses Sergei's comments.

o Fixed description and added Reported-by
o Removed NULL check for kfree()

