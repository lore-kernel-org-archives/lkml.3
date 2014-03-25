Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbaCYPVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 11:21:15 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:45221 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaCYPVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 11:21:14 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: JBottomley@parallels.com, agurumur@brocade.com, vmohan@brocade.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH resubmit] scsi: bfa: Use ARRAY_SIZE
Date: Tue, 25 Mar 2014 16:11:11 +0100
Message-Id: <1395760272-5846-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.8.5.3
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resubmission.

