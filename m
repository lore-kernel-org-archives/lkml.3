Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaIRHu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:50:57 -0400
Received: from sym2.noone.org ([178.63.92.236]:37509 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaIRHu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:50:56 -0400
Date: Thu, 18 Sep 2014 09:50:53 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Benedict Boerger <benedict.boerger@cs.tu-dortmund.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH] staging: rtl8192u: delete unused function CAM_read_entry
Message-ID: <20140918075053.GB4657@distanz.ch>
References: <1410981449-21851-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410981449-21851-1-git-send-email-benedict.boerger@cs.tu-dortmund.de>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-17 at 21:17:29 +0200, Benedict Boerger <benedict.boerger@cs.tu-dortmund.de> wrote:
> Fix the sparse warning: symbol 'CAM_read_entry' was not declared. Should it be static?
> 
> The function CAM_read_entry is not used and therefore deleted.

Your patch is missing a Signed-off-by line. Please check
Documentation/SubmittingPatches for the proper format to submit patches.
