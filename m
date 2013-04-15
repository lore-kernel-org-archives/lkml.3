Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab3DOEWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 00:22:21 -0400
Received: from nm1-vm0.bullet.mail.ird.yahoo.com ([77.238.189.95]:28020 "HELO
	nm1-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751264Ab3DOEWU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 00:22:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 970908.77102.bm@omp1026.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-RocketYMMF:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=kOOC5yF0zA9XHGlIOfEJCgpoffkyJjXooESUzAeIZU8IVUaSZPRZdVdRdHGd0+0F+LHVhSLcTbShdrymHCTotyR0bIMZ2nnE1h4wmi77TU2B74rres+8dawfSreDGYUV0PJiybQXubrhlHKqmn7C1vVPgFPZbvabeZro7JWgOG4=;
X-YMail-OSG: LdqURFYVM1lxt.lbRMYZlg3xfscTwgVijUHTvxz4w79VegD
 E3P4wk8yIzZmNwK3G5RN0s9tATXDX0Jfee1JAvBEurL.YaiXzegYLtcjUkvg
 10.HqzXjSZdaywVCXyx272ne2kp9cZc.V8VCuQsD4YUrzrLAiBfDCcGaOIhu
 ckLCCrGnC1.RM4ZWXKUsAAFo6UroM56AHc3v.Q.z8eFi_pB25f5xXe7gznEX
 kvkHhqYlBJXC.FBVxfU0kxKVWP4JRc56UT4wEov8A84Zng.LBzvTE2HEUEER
 Cbiao.BaEjK0.z4IceR1gMcrpunY2hu2QhGvyn7hMicPwoIbbrL.YljFBKiI
 pXvwBrKApBzgeQnI3E8vPbXVCigjcg1rRPvY4AGHOyy1mukjyf7hkHWNFJPx
 t10aeVyKw665nJyzScPnhvcoRRJeANlBTNFi4OCsUusjhe.79JrB1jzA0GFx
 CLkTi.wAwHbQXoy3..QBCGVaakrTblhv6FeN8eRKMdbN_snCBE4BMwAKZmeO
 CAUE6
X-Rocket-MIMEInfo: 002.001,LS0tIE9uIE1vbiwgMTUvNC8xMywgSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4gd3JvdGU6Cgo.IE9uIE1vbiwgMjAxMy0wNC0xNSBhdCAwNDo0NiArMDEwMCwKPiBIaW4tVGFrIExldW5nIHdyb3RlOgo.ID4gPiBCeSBjb252ZXJ0aW5nIHRoaXMgZHByaW50KCkgdG8gcHJfZGVidWcoKSwgaXQKPiB3b3VsZAo.ID4gPiBwcmludCBvdXQgb24gYSBtdWx0aXBsZSBsaW5lcywgb25lIGZvciBlYWNoIHJlYWQuCj4gPiA.IAo.ID4gPiBUaGF0J3Mgd2h5IGl0IHNob3VsZCB1c2UgYSBtZWNoYW5pc20gbGlrZQoBMAEBAQE-
X-RocketYMMF: hintak_leung
X-Mailer: YahooMailClassic/15.1.7 YahooMailWebService/0.8.140.532
Message-ID: <1365999738.30513.YahooMailClassic@web172302.mail.ir2.yahoo.com>
Date: Mon, 15 Apr 2013 05:22:18 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 1/2] hfs/hfsplus: Convert dprint to hfs_dbg
To: Joe Perches <joe@perches.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1365998409.1878.29.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 15/4/13, Joe Perches <joe@perches.com> wrote:

> On Mon, 2013-04-15 at 04:46 +0100,
> Hin-Tak Leung wrote:
> > > By converting this dprint() to pr_debug(), it
> would
> > > print out on a multiple lines, one for each read.
> > > 
> > > That's why it should use a mechanism like
> dbg_cont.
> > > 
> > > btw: there is no current pr_debug_cont mechanism.
> > 
> > That's rubbish.
> 
> Don't be silly.
> 
> > dprint() are compiled in/out debug printing
> statements,
> > and are entirely suppressed in unmodified kernel
> source
> 
> Of course.
> 
> > I am not saying what I have in private is correct
> 
> Then your original post wasn't useful either.
> 
> > What I am saying is that the code snipplet I posted is
> functional:
> 
> Lots of code is functional, I prefer functional
> and correct though.
> 
> cheers, Joe

Hmm, you obvious has a different meaning of "functional" than I. How is converting a few hundred lines of "print nothing" to another few hundred lines of "print nothing" functional? What does it achieve?

I have already voiced my (admittedly selfish) concern: changing a few hundred lines of "print nothing" to another few hundred lines of "print nothing" means some of us who have substantial work-in-progress patches needs to spend a fair amount of time on rebase, and manually resolving conflicts from rebase.

