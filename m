Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaIWUS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:18:28 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:54079 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaIWUS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:18:26 -0400
Date: Tue, 23 Sep 2014 16:18:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 1/6] AHCI: Cleanup checking of multiple
 MSIs/SLM modes
Message-ID: <20140923201822.GD14111@mtj.dyndns.org>
References: <cover.1411297686.git.agordeev@redhat.com>
 <e5b010c7698160c8b93c92e7463f5dbb4cf33e52.1411297686.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5b010c7698160c8b93c92e7463f5dbb4cf33e52.1411297686.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 03:19:24PM +0200, Alexander Gordeev wrote:
> Sharing Last Message (SLM) mode is currently checked in two
> functions: ahci_host_activate() and ahci_init_interrupts().
> This update consolidates SLM mode check with activation of
> multiple MSIs mode.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: linux-ide@vger.kernel.org

Applied to libata/for-3.18.

Thanks.

-- 
tejun
