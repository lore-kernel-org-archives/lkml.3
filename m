Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbbANAG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 19:06:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbbANAGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 19:06:24 -0500
Date: Wed, 14 Jan 2015 01:06:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: transaction: Remove unused function
Message-ID: <20150114000622.GO3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1421175246-6448-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421175246-6448-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 07:54:06PM +0100, Rickard Strandqvist wrote:
> Remove the function btrfs_start_transaction_lflush() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/27536

and this is my reply to 2nd attempt to remove the function:

"> btrfs_start_transaction_lflush()

Transcaction API, removing the func does not make sense without removing
BTRFS_RESERVE_FLUSH_LIMIT at the same time.
"
