Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967685AbaLLMeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:34:37 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59514 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966556AbaLLMef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:34:35 -0500
Date: Fri, 12 Dec 2014 13:34:32 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Guo-Fu Tseng <cooldavid@cooldavid.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Remove redundant function
Message-ID: <20141212123432.GA12765@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tasklet_hi_enable and tasklet_enable are redundant. Since
tasklet_hi_enable is used only 6 times in 1 file, the first
patch changes calls to the function with calls to tasklet_enable.

The second patch removes tasklet_hi_enable definition.

Quentin Lambert (2):
  jme: replace calls to redundant function
  linux/interrupt.h: remove the definition of unused tasklet_hi_enable

 drivers/net/ethernet/jme.c | 12 ++++++------
 include/linux/interrupt.h  |  6 ------
 2 files changed, 6 insertions(+), 12 deletions(-)

-- 
1.9.1

