Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaFQBXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 21:23:15 -0400
Received: from longford.logfs.org ([213.229.74.203]:43542 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaFQBXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 21:23:14 -0400
Date: Mon, 16 Jun 2014 21:20:50 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: Mateusz Guzik <mguzik@redhat.com>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>, logfs@logfs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check for Null return from logfs_readpage_nolock in
 btree_write_block
Message-ID: <20140617012050.GB14467@logfs.org>
References: <1402948021-8797-1-git-send-email-xerofoify@gmail.com>
 <20140616200625.GA27360@mguzik.redhat.com>
 <CAPDOMVgDUgfr9oqGmQ2a6u9Jm0eyBP=RP8EbCuHmnu-MRb+=+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDOMVgDUgfr9oqGmQ2a6u9Jm0eyBP=RP8EbCuHmnu-MRb+=+w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 June 2014 20:46:32 -0400, Nick Krause wrote:
> 
> You are right about the compile errors it compiles but with warning.
> I am curious since the function is void how do you want me to
> give the error back to logfs and in turn the other subsystems
> of the kernel.

My first question would be: What is the problem?  If there is no
problem, don't try to fix it.  If there is a problem, your fix should
contain a decent description of the problem as part of the commit
message.  Even if the patch itself ends up being bad, having a good
problem description with a first stab at a fix serves as a useful bug
report.

Jörn

--
Was there any time in human history where democratic forms continued
when the citizens could not credibly defend their rights?
-- Daniel Suarez
