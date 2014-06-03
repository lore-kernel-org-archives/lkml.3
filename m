Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaFCS4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:56:14 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:38318 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaFCS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:56:12 -0400
Date: Tue, 3 Jun 2014 14:56:09 -0400
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?B?Suly9G1l?= Carretero <cJ-ko@zougloub.eu>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] ahci: Add Device ID for HighPoint RocketRaid 642L
Message-ID: <20140603185609.GL26210@htj.dyndns.org>
References: <20140603145625.036687b6@Vantage>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140603145625.036687b6@Vantage>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 02:56:25PM -0400, Jérôme Carretero wrote:
> This device normally comes with a proprietary driver, using a web GUI
> to configure RAID:
>  http://www.highpoint-tech.com/USA_new/series_rr600-download.htm
> But thankfully it also works out of the box with the AHCI driver,
> being just a Marvell 88SE9235.
> 
> Devices 640L, 644L, 644LS should also be supported but not tested here.
> 
> Signed-off-by: Jérôme Carretero <cJ-ko@zougloub.eu>

Applied to libata/for-3.16 w/ stable cc'd.

Thanks.

-- 
tejun
