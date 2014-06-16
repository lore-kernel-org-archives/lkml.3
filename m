Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaFQAYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:24:39 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:57664
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752855AbaFQAYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:24:38 -0400
X-Greylist: delayed 3357 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 20:24:37 EDT
From: Anish Bhatt <anish@chelsio.com>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, akpm@linux-foundation.org,
        Anish Bhatt <anish@chelsio.com>
Subject: Re: [PATCH] checkpatch: Warn on unnecessary void function return statements
Date: Mon, 16 Jun 2014 16:28:20 -0700
Message-Id: <1402961300-17985-1-git-send-email-anish@chelsio.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1401728316.5770.9.camel@joe-AO725>
References: <1401728316.5770.9.camel@joe-AO725>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to ignore the ability to exit from void return functions via a `return;` in case of an error or similar. Any attempt to bail out generates warnings with checkpathch.pl Perhaps it should check for returns only at the end of the function ? If not, is there a suggested way to do this ? goto labels can't be directly used in place either

-Anish Bhatt
