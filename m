Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3HKQwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:52:05 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:4795 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212Ab3HKQwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:02 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717944"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/16] Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:41 +0200
Message-Id: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches replace uses of ARRAY_AND_SIZE(e) in a function argument
position by its expansion.  ARRAY_AND_SIZE(e) expands to a pair of
expressions separated by commas and thus hides the actual arity of the
called function.

I was not able to compile any of the modified code.

