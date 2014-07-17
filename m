Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaGQUHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:07:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36527 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaGQUHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:07:33 -0400
Message-ID: <1405627647.7084.59.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v6 0/6] ima: extending secure boot certificate chain of
 trust
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Date: Thu, 17 Jul 2014 16:07:27 -0400
In-Reply-To: <8821.1405626206@warthog.procyon.org.uk>
References: <1405516544.1466.50.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <53BEA780.5050602@samsung.com>
	 <1404924054.14643.36.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <24144.1404919879@warthog.procyon.org.uk>
	 <8975.1404932208@warthog.procyon.org.uk>
	 <1404941347.14643.57.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <488.1405285619@warthog.procyon.org.uk>
	 <8821.1405626206@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071720-6688-0000-0000-0000035D9E07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-17 at 20:43 +0100, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > We're already at -rc5.  Any pull requests for the next open window need
> > to submitted soon.  If/when are you planning on sending James the pull
> > request?  (I'm kind of waiting for the KEY patches to make it in, before
> > sending the linux-integrity pull request.)
> 
> Just merging it all together now on top of the same base as yours.  Is
> next-with-keys the branch I should be merging?

Yes, but you should be rebasing on top of James' #next. He just pulled
the #next-without-keys.

Mimi

