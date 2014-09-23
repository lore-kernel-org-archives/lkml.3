Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbaIWUWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:22:53 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56073 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbaIWUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:22:52 -0400
Date: Tue, 23 Sep 2014 16:22:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH RESEND v3 2/6] AHCI: Move host activation code into
 ahci_host_activate()
Message-ID: <20140923202247.GF14111@mtj.dyndns.org>
References: <cover.1411297686.git.agordeev@redhat.com>
 <4dde1cd7e44724d464b87c14c6192dec52fc8b50.1411297686.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dde1cd7e44724d464b87c14c6192dec52fc8b50.1411297686.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 03:19:25PM +0200, Alexander Gordeev wrote:
> Currently host activation done by calling either function
> ahci_host_activate() or ata_host_activate(). Consolidate
> the code by only calling ahci_host_activate() for all AHCI
> devices.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: linux-ide@vger.kernel.org

Applied to libata/for-3.18.

Thanks.

-- 
tejun
