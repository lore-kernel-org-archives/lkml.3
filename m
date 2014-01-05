Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaAESzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:55:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaAESzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:55:06 -0500
Date: Sun, 5 Jan 2014 19:55:02 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andreas Hollmann <hollmann@in.tum.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.12 spreads memory allocation across all NUMA nodes
 instead of local allocation?
Message-ID: <20140105185502.GA25160@dhcp22.suse.cz>
References: <CAGz0_-2WsqMQLqyoPJ4ncoMJ7-XhYYt_cns7Mzq0CET0=1R4SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGz0_-2WsqMQLqyoPJ4ncoMJ7-XhYYt_cns7Mzq0CET0=1R4SQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 05-01-14 13:48:23, Andreas Hollmann wrote:
> Hi,
> 
> it seems that my system (4-socket system) is
> interleaving pages across all numa nodes.

Should be fixed by fff4068cba (mm: page_alloc: revert NUMA aspect of
fair allocation policy)
 
[...]
-- 
Michal Hocko
SUSE Labs
