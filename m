Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaGAUzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:55:09 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:42530 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaGAUzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:55:06 -0400
Date: Tue, 1 Jul 2014 16:55:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Joe Perches <joe@perches.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: devres: Add devm_kmalloc() et al
Message-ID: <20140701205503.GF12459@htj.dyndns.org>
References: <1403522918-16509-1-git-send-email-daniel.thompson@linaro.org>
 <53AF6C54.4010803@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AF6C54.4010803@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 06:31:00PM -0700, Randy Dunlap wrote:
> [adding Tejun Heo]
> 
> patch OK, Tejun?  You want to apply it?

Yeah, looks good to me but it prolly should go through Greg's
driver-core-next.  Daniel, do you mind reposting it to Greg with my
ack added?

Thanks.

-- 
tejun
