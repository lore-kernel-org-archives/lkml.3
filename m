Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaLCJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:28:24 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaLCJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:28:23 -0500
Date: Wed, 3 Dec 2014 01:28:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tomas Henzl <thenzl@redhat.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Jan Vesely <jvesely@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>, hch@infradead.org
Subject: Re: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology
 change
Message-ID: <20141203092821.GA14517@infradead.org>
References: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
 <57e91c7f7bc1d3e0cd511f828ec8140b@mail.gmail.com>
 <547DC792.6070506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547DC792.6070506@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 03:07:14PM +0100, Tomas Henzl wrote:
> Hi Sreekanth,
> 
> I think this should be handled as any other change with an usual
> patch sent to the list, 'git revert 3520f9c779' and 'git revert 963ba22b90'
> will create the patches for you.

Exactly.  And now I'll need a review for them..

