Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab3GVVsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:48:45 -0400
Received: from mail-gg0-f173.google.com ([209.85.161.173]:44338 "EHLO
	mail-gg0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3GVVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:48:44 -0400
Date: Mon, 22 Jul 2013 17:40:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: agordeev@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: AHCI: ahci Driver crash in ahci_host_activate
Message-ID: <20130722214037.GE16776@mtj.dyndns.org>
References: <51E40268.3030009@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E40268.3030009@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 15, 2013 at 09:08:40AM -0500, Suravee Suthikulanit wrote:
> I ran into a crash during booting with the latest 3.11.0-rc1.  After
> investigation, the crash was triggered by the patch below where the
> "pp" is NULL in some cases.

Yeap, fix is being worked on.  Thanks a lot!

-- 
tejun
