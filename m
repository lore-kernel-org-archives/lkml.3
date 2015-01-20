Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbbATLT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:19:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbbATLTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:19:55 -0500
Date: Tue, 20 Jan 2015 11:19:51 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: agk@redhat.com, linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND] md:Remove no longer needed fix me
	comment in dm-region-hash.c for removing the structure pointer, *rh
	from the definiton of dm_region
Message-ID: <20150120111951.GB17599@agk-dp.fab.redhat.com>
Mail-Followup-To: Nicholas Krause <xerofoify@gmail.com>, agk@redhat.com,
	linux-raid@vger.kernel.org, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, snitzer@redhat.com
References: <1421723781-21984-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421723781-21984-1-git-send-email-xerofoify@gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 10:16:21PM -0500, Nicholas Krause wrote:
> Removes the no longer needed fix me comment questioning if we need to remove
> the structure pointer,rh as defined as a structure of type dsm_region_hash
> from the definition of the structure, dm_region. Furthermore this  pointer is
> needed in order for various functions to run and build successfully in the file,
> dm-region-hash.c.
 
You've misunderstood the comment!
Is there a better alternative to having every dm_region struct store its own copy of
this pointer?

Alasdair

