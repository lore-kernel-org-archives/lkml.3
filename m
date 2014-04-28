Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaD1Eja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:39:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaD1Ej2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:39:28 -0400
Date: Sun, 27 Apr 2014 21:39:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V1 00/22]  New ACL format for better NFSv4 acl
 interoperability
Message-ID: <20140428043909.GA26778@infradead.org>
References: <1398615293-22931-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398615293-22931-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't address any or the previous points:

 - common implementation instead of the godawful boilerplate code
   (and we even fixed most of this for Posix ACL by now, so even less
   reason to do the same crap again!)
 - common data structure with Posix ACLs

And of course no real explanation why we need the braindead access/deny
scheme at how it will get properly integrated with the system.

So in this for a clear NAK.
