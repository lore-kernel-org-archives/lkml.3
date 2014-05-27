Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaE0WkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:40:00 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47989 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaE0Wj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:39:59 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Borislav Petkov <bp@alien8.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: Use symbolic defines for console loglevels
In-Reply-To: Your message of "Tue, 27 May 2014 21:43:59 +0200."
             <20140527194359.GD4366@pd.tnic>
From: Valdis.Kletnieks@vt.edu
References: <1400524052-25625-1-git-send-email-bp@alien8.de> <20140527151728.64e8cf59@gandalf.local.home>
            <20140527194359.GD4366@pd.tnic>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1401230184_14392P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 May 2014 18:36:24 -0400
Message-ID: <34707.1401230184@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1401230184_14392P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 May 2014 21:43:59 +0200, Borislav Petkov said:
> On Tue, May 27, 2014 at 03:17:28PM -0400, Steven Rostedt wrote:
> > This looks like functionality change to me.
> >
> > Please make the fix of "==" --> ">=" a separate patch.
>
> Yeah, that's actually a fix for console_loglevel values > 10. I don't
> think it is worth the effort of splitting though ... unless you have a
> real good reason.

If you don't split it out, you should at least mention the bugfix in the
changelog....

--==_Exmh_1401230184_14392P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU4UTaAdmEQWDXROgAQL6dg//SvAX3G0OYJT7aSTo4xfHkoxfSZC+cv85
ARFnAPADp75ZlkQQIGwLH4TWZy3GAFWo5kr5GrBZR0GW/EmBhDxsRlrpybRAWY8P
GlCIeQK/a1LWt/DsuWHKWmiyyXHdmxQcJNB0V3wtipJKGTU6Qsieu3XF5CSBrF5h
xVZX8QRC+L/5krrB2AfHXHXGGK2H+wNoXUDJpXzZ5j7Njtg+vWcEtNUps/uYkwD+
3liTtVZ6jao7zv39+7XWN+SkgFvXZoQKuUUIrVn6EVTYumhFFTXikYEMQrruyQAA
2SWrUVbGsdiTxTqQU+fUnQNlfyzBGyDR+LtWDLPF1GD9dLTOjUM/vYy+Gw5UU/cv
2YMGvIUZktnMnIlz19kCNN30ta3wJjCwjxDEUN3faqDHD9ktG2us6K8+Jjacck2f
pjv3v6wbqIwuS/J4JzbD5nykjeaIcUVdA0kgggfjEA8JcCnUEubgqt4JyVA48Vwh
9t3hKhERt+v9PX3cbOTkvkpLRH+VavtL2vbwMNMRFS+5DCsLdXJGnRBYtWLtmamb
2y4jzeoqnbQ4DKAll34bxzOeTbFPSoAq8I6dXppWmStCmlLuFMoWuncM4Jzwizy8
A2sBSmkMS86nWCadx7MXDswRaltDVkHiN27IypZMCanaUQcO5J1EUY6SgBMxOoGs
Y40KwZRfGWc=
=escV
-----END PGP SIGNATURE-----

--==_Exmh_1401230184_14392P--
