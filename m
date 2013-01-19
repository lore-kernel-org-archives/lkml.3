Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3ASDJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 22:09:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47069 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab3ASDJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 22:09:20 -0500
Date: Sat, 19 Jan 2013 03:09:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 16/76] ARC: Syscall support (no-legacy-syscall ABI)
Message-ID: <20130119030918.GA23552@ZenIV.linux.org.uk>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
 <1358511930-7424-17-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358511930-7424-17-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, collapse your #36--#40 into that one (and I'd probably fold #17
here as well, to simplify that reordering).  Sure, it's not a bisection
hazard, but...
