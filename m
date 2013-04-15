Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab3DODwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:52:15 -0400
Received: from nm24-vm6.bullet.mail.ird.yahoo.com ([212.82.109.197]:27504 "HELO
	nm24-vm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754921Ab3DODwO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:52:14 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Apr 2013 23:52:13 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 701600.59651.bm@omp1048.mail.ir2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-RocketYMMF:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VFUlHnIYgLaSD52cJaD93fZaEDm6/64B7FxHRofu0mq2LjiWlEnms+aF/XVyv4GDj6R7I2oGfds4ouX3GRYHPb/OoPApkLHSr0HI0dI6ET8m1FNv9+xQiCjOd6cSQ7noWzO6x8f4mSsxHVkQAk+lUbBzo/gNJ2ohy0ONtWNsg4E=;
X-YMail-OSG: C34SvtIVM1l8dpFrlq1l64alC1F6zZDo3ItI8QXkJ0OBap0
 PepjkYhIAVyGPgFYgO2iSDWLgqeGM_c57TFNFiPvoK3svXRlVtxDjzYxo8Vx
 D96kfdRUXkCFMHNKd6HFI3SZ6KZ1p99YuxJJpm2.7Lcll6y0_QwqutJhKimX
 TYEkmIcNiGz5hNx9bi7vBN70yut1QrNPXtoTjpiTWB1i3dWRimBMb7mwTP1M
 1i0xllU8RjGP5iabdDpbnS3XMnm8RbTiDUGN_2EUZ_mMuIRawEFpTkDRDjkr
 upWtwYYvQGjmdOcdinE_4_KaLE1L91hmULSViIegL5NfYQcMgHmrvP7byyaf
 rGWnH2EC0rBtV7EtppmcszPoZnLMXvckyuCBzzt2J_BnDkpZ02kmbfvnK8hW
 cdzeu9SY_d2p7HtPIHEVqcs6S955ARMBw00LYBjoC6WFMWz_LTW6m3hNHorY
 3nuJNulmLf4ch10t6cVfx_3HA9u2Ae0tST5WzVEFrFDlmmKLsF2EMzRx4BPR
 f0wY8
X-Rocket-MIMEInfo: 002.001,LS0tIE9uIE1vbiwgMTUvNC8xMywgSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4gd3JvdGU6Cgo.IE9uIE1vbiwgMjAxMy0wNC0xNSBhdCAwMjo1NiArMDEwMCwKPiBIaW4tVGFrIExldW5nIHdyb3RlOgo.ID4gLS0tIE9uIE1vbiwgMTUvNC8xMywgSm9lIFBlcmNoZXMgPGpvZUBwZXJjaGVzLmNvbT4KPiB3cm90ZToKPiA.ID4gT24gTW9uLCAyMDEzLTA0LTE1IGF0IDAxOjUzICswMTAwLAo.ID4gPiBIaW4tVGFrIExldW5nIHdyb3RlOgo.ID4gPiA.IC0tLSBPbiBNb24sIDgvNC8xMywgSm9lIFBlcmNoZXMBMAEBAQE-
X-RocketYMMF: hintak_leung
X-Mailer: YahooMailClassic/15.1.7 YahooMailWebService/0.8.140.532
Message-ID: <1365997619.11055.YahooMailClassic@web172306.mail.ir2.yahoo.com>
Date: Mon, 15 Apr 2013 04:46:59 +0100 (BST)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 1/2] hfs/hfsplus: Convert dprint to hfs_dbg
To: Joe Perches <joe@perches.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1365991579.1878.26.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 15/4/13, Joe Perches <joe@perches.com> wrote:

> On Mon, 2013-04-15 at 02:56 +0100,
> Hin-Tak Leung wrote:
> > --- On Mon, 15/4/13, Joe Perches <joe@perches.com>
> wrote:
> > > On Mon, 2013-04-15 at 01:53 +0100,
> > > Hin-Tak Leung wrote:
> > > > --- On Mon, 8/4/13, Joe Perches <joe@perches.com>
> wrote:
> > > > > Use a more current logging style.
> > > []
> > > > I have been sitting on a patch which changes
> this part
> > > of the code to dynamic debugging, and it is much
> simplier.
> []
> > > This change wouldn't work well as it would make a
> mess
> > > of output that uses no prefix (ie: emits at
> KERN_DEFAULT)
> > > with output that uses KERN_DEBUG
> > > 
> > > That's the reason for _dbg and _dbg_cont.
> > 
> > Hmm, I don't get it. Is there any *existing* use of
> dprint
> > in the hfplus code which is affected by your comment?
> 
> Code like this prints out currently on a single line at
> KERN_DEFAULT.
> 
> @@ -138,16 +138,16 @@ void hfs_bnode_dump(struct hfs_bnode
> *node)
> []
>         for (i =
> be16_to_cpu(desc.num_recs); i >= 0; off -= 2, i--) {
>                
> key_off = hfs_bnode_read_u16(node, off);
> -           
>    dprint(DBG_BNODE_MOD, " %d", key_off);
> +           
>    hfs_dbg_cont(BNODE_MOD, " %d", key_off);
> 
> By converting this dprint() to pr_debug(), it would
> print out on a multiple lines, one for each read.
> 
> That's why it should use a mechanism like dbg_cont.
> 
> btw: there is no current pr_debug_cont mechanism.

That's rubbish. dprint() are compiled in/out debug printing statements, and are entirely suppressed in unmodified kernel source (the value of DBG_MASK being zero). So your rather large and invasive change - which is still conditional on DBG_MASK - is just substituting one form of print nothing to another form of print nothing.

I am not saying what I have in private is correct - otherwise I would have submitted it a long time ago. What I am saying is that the code snipplet I posted is functional: it is not conditional on DBG_MASK, but conditional on the meaning of pr_debug (and only on it), which is either printing indiscriminantly, or on/off switchable at runtime for dynamically enabled kernel. And it is a small and non-invasive change in any case, which I can hang on to indefinitely.

I think the current *implementation* of dprint is bad - it depending on a modification of kernel source and re-compilation to make debug statement visible instead of the default "print nothing". But your patch, which modifies a lot of "print nothing" to another style of "print nothing", has no functional consequence at all. There is no user-visible change. It changes a few hundred lines of print nothing to another few hundred lines of print nothing.



 
