Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542AbaFQPnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:43:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53365 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbaFQPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:43:34 -0400
Date: Tue, 17 Jun 2014 08:47:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, stefanr@s5r6.in-berlin.de, joro@8bytes.org,
        jejb@parisc-linux.org, deller@gmx.de, bhelgaas@google.com, clm@fb.com,
        Josef Bacik <jbacik@fb.com>, swhiteho@redhat.com, bharrosh@panasas.com,
        bhalevy@primarydata.com, ccaulfie@redhat.com, teigland@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        jaegeuk@kernel.org, cm224.lee@samsung.com,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        casey@schaufler-ca.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/24] kobject: return actual error on kset_create_and_add
Message-ID: <20140617154730.GA14153@kroah.com>
References: <53A04FF7.5050900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A04FF7.5050900@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 10:25:59PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> It's better to return the actual error rather than NULL because
> kset_register() can failed due to other reasons.

Why?

Who really cares about that?  What can do you do with that additional
information that will help anything out?

In other words, what benifit does this patch create to justify the large
churn it is going to cause?

thanks,

greg k-h
