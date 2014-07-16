Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933269AbaGPA5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:57:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944AbaGPA5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:57:00 -0400
Message-ID: <1405472202.5592.4.camel@fourier>
Subject: Re: DO NOT APPLY: x86-64, espfix: Don't leak bits 31:16 of %esp
 returning to 16-bit stack
From: Kamal Mostafa <kamal@canonical.com>
To: Andrew Lutomirski <amluto@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Date: Tue, 15 Jul 2014 17:56:42 -0700
In-Reply-To: <CAObL_7EUh0F32yU+dWw802GhMp2zqaZsjc_iK-sKPnyBeJFMyA@mail.gmail.com>
References: <CAObL_7EUh0F32yU+dWw802GhMp2zqaZsjc_iK-sKPnyBeJFMyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 16:21 -0700, Andrew Lutomirski wrote:
> On Tue, Jul 15, 2014 at 2:28 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> > 3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: "H. Peter Anvin" <hpa@linux.intel.com>
> >
> > commit 3891a04aafd668686239349ea58f3314ea2af86b upstream.
> 
> Do not apply to any -stable release yet.  This causes nasty regressions on Xen.
> 
> --Andy
> 


Thanks very much Andy.  I've dropped it from the 3.13-stable queue.

 -Kamal


