Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbaGBABY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:01:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbaGBABX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:01:23 -0400
Date: Wed, 2 Jul 2014 02:01:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] FS/BTRFS: replace count*size kzalloc by kcalloc
Message-ID: <20140702000121.GW1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Fabian Frederick <fabf@skynet.be>,
	linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
	Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
References: <1403721343-19383-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403721343-19383-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 08:35:43PM +0200, Fabian Frederick wrote:
> kcalloc manages count*sizeof overflow.
> 
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Reviewed-by: David Sterba <dsterba@suse.cz>
