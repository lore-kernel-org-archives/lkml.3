Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab3CNPvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:51:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54973 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3CNPvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:51:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [RFC 00/17] Remove GENERIC_GPIO from architecture code
Date: Thu, 14 Mar 2013 15:50:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com> <CACRpkdYs0MG3L4ti8tmVpwynVMMWKEVYdiOr+EG2ad2Z9D7x7A@mail.gmail.com> <CAAVeFuKsMVnof8pO_M1ju3TezpzTF+0c4419ks5GrEsWmusNTA@mail.gmail.com>
In-Reply-To: <CAAVeFuKsMVnof8pO_M1ju3TezpzTF+0c4419ks5GrEsWmusNTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303141550.49592.arnd@arndb.de>
X-Provags-ID: V02:K0:iantx2MKG6Al2cZ1Lhb1hoUuVGERQOuubEQAC4oN2RP
 /RDDHcGD+s39yhs1KOSshBxEAFrJUdzoVLtX2LTJcB9tPJXgB7
 fHphugB80KflmCrIQ4xy8RD4fpJ8vGtDAgTxTrq3RM4rMgpndR
 kx8QKiHVVcirmMNd7klWU33R3qcAd7fRGyTzu/r5SnfWUtNtp9
 L5Mkl0EnYrQpw+m2eEZDE4H0WM4aACHOO/+/t66r0P3/yDnEMI
 k9GSc0C14q/3BNOBhvi0uD9HH7fmYwHx9izF8nnOfkmdCKd3Bf
 R8vcsEHCrD1AcaRAtyG/PuMIoyMHbRMcNJV5XLAlFJIwlznwna
 sVBwf5qOKwf/g+ShaUVU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 March 2013, Alexandre Courbot wrote:
> 
> On Thu, Mar 14, 2013 at 11:14 PM, Linus Walleij
> <linus.walleij@linaro.org> wrote:
> > For submitting the pull request to Torvalds in the end you will need
> > to create a signed tag. Do you have a signed GPG key? Else it's
> > about time to create a key and start collecting signatures... then you
> > can also get a repo at kernel.org in the future.
> 
> I have one or two signatures of kernel devs on my GPG key, but I
> thought that maybe this set could be pulled by you or Grant once it
> has undergone enough testing - it's not like I intend to push
> regularly on this branch.
> 
> If I understand correctly the reason for having this in its own branch
> is to be able remove it quickly would it attempt to screw the dog.

The main reason I think is so that branch can be pulled by other
people that don't want to pull in all of the other gpio changes.

It could still just be another branch in the existing gpio tree,
at least once everyone is happy with the state of the patches.

	Arnd
