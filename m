Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaHMVv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 17:51:57 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18818 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaHMVv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 17:51:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Aug 2014 14:38:37 -0700
Message-ID: <53EBDF31.7010204@nvidia.com>
Date: Wed, 13 Aug 2014 14:57:05 -0700
From: Matt Longnecker <mlongnecker@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <mattias.nissler@gmx.de>
Subject: debugfs_create_{u,x,s}{8,16,32,64}
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Back in December 2007 Mattias Nissler proposed a patch defining 
debugfs_create_s32 and friends. In it he reworked the already existent u 
and x versions. The subject of Mattias's mail was "[PATCH] debugfs: 
Revamp debugfs_create_{u,x,s}{8,16,32,64} to support signed integers".

As I'm writing a new driver related to thermal management, I'm finding 
the absence of debugfs_create_s32 to be a stumbling block. I see at 
least two other folks who have stumbled on the absence of 
debugfs_create_s32 in the past few years.

Why didn't we merge Mattias's patch? Would you entertain a similar patch 
today?

Thanks,
Matt Longnecker
