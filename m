Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbbAFKmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:42:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbbAFKmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:42:10 -0500
Date: Tue, 6 Jan 2015 11:42:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: David Sterba <dsterba@suse.cz>
cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: reada: Remove unused function
In-Reply-To: <20150105133356.GF6114@twin.jikos.cz>
Message-ID: <alpine.LRH.2.00.1501061141250.20601@twin.jikos.cz>
References: <1420333197-6245-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <20150105133356.GF6114@twin.jikos.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2015, David Sterba wrote:

> > Remove the function btrfs_reada_detach() that is not used anywhere.
> > 
> > This was partially found by using a static code analysis program called cppcheck.
> > 
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> 
> No please, this function is part of public readahead API and similar
> patch has been NACKed several times.

BTW how is this any kind of API for anybody, given it's not exported to 
modules?

-- 
Jiri Kosina
SUSE Labs

