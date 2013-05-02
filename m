Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3EBBdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:33:55 -0400
Received: from intranet.asianux.com ([58.214.24.6]:25713 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3EBBdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:33:52 -0400
X-Spam-Score: -100.8
Message-ID: <5181C251.9020301@asianux.com>
Date: Thu, 02 May 2013 09:33:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jonghwan Choi <jhbird.choi@samsung.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Al Viro'" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.8-stable]  kernel/audit_tree.c: tree will leak memory
 when failure occurs in audit_trim_trees()
References: <007001ce457e$dcfff1c0$96ffd540$%choi@samsung.com>
In-Reply-To: <007001ce457e$dcfff1c0$96ffd540$%choi@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月30日 16:44, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?

For me, I recommend it.  :-)

Thanks.

-- 
Chen Gang

Asianux Corporation
