Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbbAUMby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:31:54 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:50061 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbAUMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:31:46 -0500
Date: Wed, 21 Jan 2015 07:31:34 -0500
From: Tejun Heo <tj@kernel.org>
To: Thierry Reding <treding@nvidia.com>
Cc: Paul Walmsley <paul@pwsan.com>, gregory.clement@free-electrons.com,
        hdegoede@redhat.com, pwalmsley@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: next-20150120 broken on Tegra by "ata: libahci: Allow using
 multiple regulators"
Message-ID: <20150121123134.GD8684@htj.dyndns.org>
References: <alpine.DEB.2.02.1501210003010.5450@utopia.booyaka.com>
 <20150121105001.GA9921@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121105001.GA9921@ulmo.nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 11:50:03AM +0100, Thierry Reding wrote:
> Tejun, preferably the attached patch should be squashed into commit
> c7d7ddee7e24 ("ata: libahci: Allow using multiple regulators") to avoid
> breaking bisectability. If you don't want to rewrite history, let me
> know and I can turn it into a proper patch.

Yes, please make it a proper patch.

Thanks a lot!

-- 
tejun
