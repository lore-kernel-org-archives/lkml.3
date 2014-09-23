Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaIWNRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:17:36 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58972 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaIWNRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:17:34 -0400
Date: Tue, 23 Sep 2014 09:17:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] ahci-platform: Bump max number of clocks to 5
Message-ID: <20140923131730.GD14905@mtj.dyndns.org>
References: <1411416586-18320-1-git-send-email-galak@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411416586-18320-1-git-send-email-galak@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:09:45PM -0500, Kumar Gala wrote:
> Qualcomm IPQ806x SoCs with SATA controllers need 5 clocks to be enabled.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>

Applied 1-2 to libata/for-3.18.

Thanks.

-- 
tejun
