Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030210AbaGOXWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:22:11 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:53123 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933219AbaGOXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:22:07 -0400
MIME-Version: 1.0
From: Andrew Lutomirski <amluto@gmail.com>
Date: Tue, 15 Jul 2014 16:21:46 -0700
Message-ID: <CAObL_7EUh0F32yU+dWw802GhMp2zqaZsjc_iK-sKPnyBeJFMyA@mail.gmail.com>
Subject: DO NOT APPLY: x86-64, espfix: Don't leak bits 31:16 of %esp returning
 to 16-bit stack
To: Kamal Mostafa <kamal@canonical.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 2:28 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> 3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: "H. Peter Anvin" <hpa@linux.intel.com>
>
> commit 3891a04aafd668686239349ea58f3314ea2af86b upstream.

Do not apply to any -stable release yet.  This causes nasty regressions on Xen.

--Andy
