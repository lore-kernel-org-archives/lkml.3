Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab3HNU1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:27:35 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:59013 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab3HNU1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:27:33 -0400
Date: Wed, 14 Aug 2013 16:27:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v4 1/3] devicetree: create a separate binding description
 for sata_highbank
Message-ID: <20130814202728.GJ28628@htj.dyndns.org>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
 <1376504612-17340-1-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376504612-17340-1-git-send-email-mark.langsdorf@calxeda.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 14, 2013 at 01:23:30PM -0500, Mark Langsdorf wrote:
>  Documentation/devicetree/bindings/ata/sata_highbank.txt | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Any ideas on how these should be routed?  The above doesn't apply to
libata or master as the file doesn't exist there yet.

Thanks.

-- 
tejun
