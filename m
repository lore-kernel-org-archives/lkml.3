Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaIPPfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:35:14 -0400
Received: from plane.gmane.org ([80.91.229.3]:41904 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbaIPPfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:35:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andras Kovacs <neoteny@freemail.hu>
Subject: Question re: blk-mq and UFS driver
Date: Tue, 16 Sep 2014 15:28:06 +0000 (UTC)
Message-ID: <loom.20140916T172224-80@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 24.68.136.144 (Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:26.0) Gecko/20100101 Firefox/26.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Is it true that the blk-mq code is entirely transparent to low level drivers
(in particular to the UFS driver, ufshcd.c and associated files)? Or are
there any changes which have to be made to the UFS driver to take advantage
of the performance improvements flowing from the blk-mq code?

Any pointer would be greatly appreciated.


