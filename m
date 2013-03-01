Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3CAI0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:26:15 -0500
Received: from 82-69-66-36.dsl.in-addr.zen.co.uk ([82.69.66.36]:64544 "EHLO
	gateway.l8s.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3CAI0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:26:13 -0500
X-Greylist: delayed 1381 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 03:26:12 EST
Date: Fri, 1 Mar 2013 08:17:29 +0000
From: David Laight <david@l8s.co.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Pavel Shilovsky <piastry@etersoft.ru>, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, wine-devel@winehq.org
Subject: Re: [PATCH v3 0/7] Add O_DENY* support for VFS and CIFS/NFS
Message-ID: <20130301081729.GT5181@snowdrop.l8s.co.uk>
Mail-Followup-To: Andy Lutomirski <luto@amacapital.net>,
	Pavel Shilovsky <piastry@etersoft.ru>,
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	wine-devel@winehq.org
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru> <512FD1D5.3010106@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512FD1D5.3010106@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 01:53:25PM -0800, Andy Lutomirski wrote:
> > O_DENYMAND - to switch on/off three flags above.
> 
> O_DENYMAND doesn't deny anything.  Would a name like O_RESPECT_DENY be
> better?

Possibly rename to O_CHECK_DENY ?

	David

-- 
David Laight: david@l8s.co.uk
