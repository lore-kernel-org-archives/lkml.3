Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbbAIWC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:02:58 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:54656 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbAIWC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:02:57 -0500
Date: Fri, 9 Jan 2015 17:02:53 -0500
From: Tejun Heo <tj@kernel.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA link power management issues
Message-ID: <20150109220253.GI2785@htj.dyndns.org>
References: <3352987.ugV1Ipy7Z5@xps13>
 <20150109220018.GH2785@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150109220018.GH2785@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 05:00:18PM -0500, Tejun Heo wrote:
> It's not normal.  It definitely doesn't happen with all devices.  I
> guess it could be a quirk from the device side.  What's on the other
> side of the connector?  Can you post the full kernel log after such
> incidence?

What happens if you comment out the DIPM part of ata_eh_set_lpm() -
the first ata_for_each_dev() loop in the function?

Thanks.

-- 
tejun
