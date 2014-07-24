Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760AbaGXWld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:41:33 -0400
Received: from sam.nabble.com ([216.139.236.26]:47393 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759678AbaGXWlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:41:32 -0400
Date: Thu, 24 Jul 2014 15:41:31 -0700 (PDT)
From: yuanh <yuanhp_china@hotmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1406241691732-911707.post@n7.nabble.com>
Subject: linux fsync behaviour
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

   Two file descriptors are pointing the same file. When fsync is called on
one fd, the data written by the other fd will also be flushed? We are using
linux XFS.

 Thanks,

-Yuan



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/linux-fsync-behaviour-tp911707.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
