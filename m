Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab3BFRQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:16:25 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:44651 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab3BFRQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:16:23 -0500
Date: Wed, 6 Feb 2013 10:16:07 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Dan.Morav@nuvoton.com, linux-security-module@vger.kernel.org,
        mathias.leblanc@st.com
Subject: Re: [tpmdd-devel] TPM drivers' submission statuses
Message-ID: <20130206171607.GA28995@obsidianresearch.com>
References: <20130206154618.GA8296@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206154618.GA8296@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 09:46:18AM -0600, Kent Yoder wrote:
> Hi,
> 
>   Occasionally I get a note from someone who's been pointed to me as
> having the latest version of a driver that isn't upstream.  The last
> submitted version of these drivers are usually sitting on the list,
> waiting on attention from their submitter. Hopefully I've added all the
> relevant folks on cc here, both submitters and reviewers.
> 
>   Here's the status of these drivers, from oldest to newest:
> 
> Nuvoton i2c:
>   Submitted to me off list. Review found issues. Needs resubmission
> to LKML. Last seen on the list:  https://lkml.org/lkml/2012/2/7/167

> Atmel i2c:
>   Submitted to tpmdd-devel for review. Waiting on a review from me.

FWIW, I have boards here with both of these chips and am very
interested in seeing support for these reach mainline.

I can look at and test the patches as well, if someone would send the
latest versions my way.

Regards,
Jason
