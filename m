Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaGHQHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaGHQHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:07:42 -0400
Date: Tue, 8 Jul 2014 12:07:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org,
        dhowells@redhat.com, pjones@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/9] kexec: Verify signature of PE signed bzImage
Message-ID: <20140708160720.GA13135@redhat.com>
References: <1404421641-12691-1-git-send-email-vgoyal@redhat.com>
 <20140704145118.GD3340@pd.tnic>
 <20140705030134.GA18508@redhat.com>
 <20140708155414.GE27659@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708155414.GE27659@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:54:14PM +0200, Borislav Petkov wrote:
> On Fri, Jul 04, 2014 at 11:01:34PM -0400, Vivek Goyal wrote:
> > Given that this time we have a new use case, I am hoping that idea of
> > parsing PE and verifying signature is more acceptable.
> 
> Maybe.
> 
> In any case, I still think that you should post the full patch set and
> not refer to some repo so that people can take a look at the whole
> thing.
> 

Is referring to other posting is fine?

David Howells just posted PKCS7 patches on lkml.

https://lkml.org/lkml/2014/7/8/332

> I'll fiddle them out now from David's branch but please add them to your
> next submission.

So may be I can refer to above post in my next posting. Will that work? As
he is working on the those patches, I thought it would make sense if he
does the posting and I simply refer to these patches.

Thanks
Vivek
