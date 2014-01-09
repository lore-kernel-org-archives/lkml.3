Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaAIPA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:00:29 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:64965 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaAIPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:00:21 -0500
Date: Thu, 9 Jan 2014 10:00:16 -0500
From: Tejun Heo <tj@kernel.org>
To: Roger Quadros <rogerq@ti.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, kishon@ti.com,
        b.zolnierkie@samsung.com, hdegoede@redhat.com, arnd@arndb.de,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Balaji T K <balajitk@ti.com>
Subject: Re: [PATCH v4 2/3] ata: ahci_platform: Manage SATA PHY
Message-ID: <20140109150016.GA18867@htj.dyndns.org>
References: <1389264962-22858-1-git-send-email-rogerq@ti.com>
 <1389264962-22858-3-git-send-email-rogerq@ti.com>
 <52CE85E9.7040703@cogentembedded.com>
 <52CE89F9.4040908@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CE89F9.4040908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 05:07:29PM +0530, Roger Quadros wrote:
> I know it is pointless functionally, but it is just my preference
> aesthetically.
> 
> Is it much of an issue if left as is?

Yes.

-- 
tejun
