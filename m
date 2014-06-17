Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbaFQQAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:00:35 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:36469 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933681AbaFQQAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:00:32 -0400
Date: Tue, 17 Jun 2014 11:00:25 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Greg KH <gregkh@linuxfoundation.org>
cc: Jeff Liu <jeff.liu@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 01/24] kobject: return actual error on
 kset_create_and_add
In-Reply-To: <20140617154730.GA14153@kroah.com>
Message-ID: <alpine.DEB.2.11.1406171057270.20610@gentwo.org>
References: <53A04FF7.5050900@oracle.com> <20140617154730.GA14153@kroah.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Greg KH wrote:

> Who really cares about that?  What can do you do with that additional
> information that will help anything out?

The obvious reason for doing so is so that one can put the error code into
a log message to get more detailed information on why the call failed.

In this particular case the slab allocator can give an error message that
gives a hint why the sysfs support could not be enabled.


