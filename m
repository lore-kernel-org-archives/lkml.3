Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab3EaLce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:32:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab3EaLc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:32:28 -0400
Date: Fri, 31 May 2013 13:32:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Fix adjust_range_size_mask calling position
Message-ID: <20130531113224.GA7131@gmail.com>
References: <CAE9FiQXr4S0P5P5JdegRyozSX4OCJ6+6MMybmAaMPCzfqe6yWg@mail.gmail.com>
 <1369861769-30687-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369861769-30687-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Commit 8d57470d cause a kernel panic while setting mem=2G.

'Commit 8d57470d' is not the standard way of how we refer to upstream 
commits in changelogs. See commit 5e427ec2d066 as an example for the 
proper format.

Thanks,

	Ingo
