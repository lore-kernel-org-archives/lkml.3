Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3KWWsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 17:48:40 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:56263 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3KWWsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 17:48:38 -0500
Date: Sat, 23 Nov 2013 17:48:35 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: [PATCHSET driver-core-next] sysfs: separate out kernfs, take #3
Message-ID: <20131123224835.GA29774@mtj.dyndns.org>
References: <1385245346-856-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385245346-856-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please hold on a bit.  I have !CONFIG_SYSFS build failure.  I think I
forgot to add dummy interface for a newly added function.  I'm fixing
it right now.

Thanks.

-- 
tejun
