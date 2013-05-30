Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967728Ab3E3HDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:03:51 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39769 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967671Ab3E3HD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:03:28 -0400
Date: Thu, 30 May 2013 16:03:23 +0900
From: Tejun Heo <tj@kernel.org>
To: chew chiau ee <chiauee85@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>
Subject: Re: [PATCH] ata_piix: add PCI IDs for Intel BayTail
Message-ID: <20130530070323.GD22604@mtj.dyndns.org>
References: <1368689609-26864-1-git-send-email-chiauee85@gmail.com>
 <20130516180728.GC7171@mtj.dyndns.org>
 <20130516181857.GD7171@mtj.dyndns.org>
 <CAA9G2fWUZy3-QDMjGm2vZkZfoyvKiQO-kM3-6jHNUiQ62tHXVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9G2fWUZy3-QDMjGm2vZkZfoyvKiQO-kM3-6jHNUiQ62tHXVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 03:02:41PM +0800, chew chiau ee wrote:
> Baytrail supports only two SATA ports.
> Baytrail is using the mapping table of ich8_2port_map_db  while SNB is
> using mapping table of  ich8_map_db.

Ah, alright.  Thanks for the explanation. :)

-- 
tejun
