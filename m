Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaKEQcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:32:05 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:59555 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbaKEQcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:32:02 -0500
Date: Wed, 5 Nov 2014 11:31:59 -0500
From: Tejun Heo <tj@kernel.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: bhelgaas@google.com, aaron.lu@intel.com, rjw@rjwysocki.net,
        mister.freeman@laposte.net, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
Message-ID: <20141105163159.GE14386@htj.dyndns.org>
References: <1415149665-26669-1-git-send-email-chuansheng.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415149665-26669-1-git-send-email-chuansheng.liu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 09:07:45AM +0800, Chuansheng Liu wrote:
> The JMicron chip 361/363/368 contains one SATA controller and
> one PATA controller, they are brother-relation ship in PCI tree,
> but for powering on these both controller, we must follow the
> sequence one by one, otherwise one of them can not be powered on
> successfully.
> 
> So here we disable the async suspend method for Jmicron chip.
> 
> Cc: stable@vger.kernel.org # 3.15+
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>

Applied to libata/for-3.18-fixes.

Thanks.

-- 
tejun
