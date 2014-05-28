Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaE1L1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:27:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaE1L1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:27:24 -0400
Date: Wed, 28 May 2014 04:27:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Masanari Iida <standby24x7@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvsas: mv_sas.c:  Fix for possible null pointer
 dereference
Message-ID: <20140528112721.GC11953@infradead.org>
References: <1400429547-11342-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400429547-11342-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 06:12:26PM +0200, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Looks good, although I'd love to know how a NULL dev could even happen
here.

Reviewed-by: Christoph Hellwig <hch@lst.de>
