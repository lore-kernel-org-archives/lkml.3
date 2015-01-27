Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbbA0D2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:28:00 -0500
Received: from pb-smtp1.int.icgroup.com ([208.72.237.35]:62056 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751663AbbA0D1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=XdIu91Ifu/Ao2eDNYFXWd4kn/bcsfNbp
	9mNMsxGLEOxUe+BA7mRA/emBrHToOa5BYD9jNEKgNvI5KWauTtt+s7FhdwgsvKh8
	4tLu3B8e+qcb1EOv1hbYqhd4wNVc55jTTh1xi5gct21VbHutNK4A8KZjK1UTPxCf
	rlF12bNJtMQ=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        twaugh@redhat.com, Git Mailing List <git@vger.kernel.org>
Subject: Re: patch-2.7.3 no longer applies relative symbolic link patches
References: <CA+5PVA7rVy6Li_1haj1QmGG0D6avLB5Xej=2YGt6K-11kKHR5A@mail.gmail.com>
	<CA+5PVA4bs6CYU8MHn1JqBjnb-5wYJT2Tjqa65=v2uSPL8c7dYw@mail.gmail.com>
	<CA+55aFxbY21vBbPs5qCFPT1HSBbaeS+Z2Fr9So1r3rXrMWe_ZQ@mail.gmail.com>
Date: Mon, 26 Jan 2015 19:27:12 -0800
In-Reply-To: <CA+55aFxbY21vBbPs5qCFPT1HSBbaeS+Z2Fr9So1r3rXrMWe_ZQ@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 26 Jan 2015 12:44:33 -0800")
Message-ID: <xmqqzj94lx7z.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Pobox-Relay-ID: 62BBCCAA-A5D4-11E4-B9F4-7BA29F42C9D4-77302942!pb-smtp1.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Ugh. I don't see anything we can do about this on the git side, and I
> do kind of understand why 'patch' would be worried about '..' files.
> In a perfect world, patch would parse the filename and see that it
> stays within the directory structure of the project, but that is a
> rather harder thing to do than just say "no dot-dot files".

It is unclear to me why "limit to the current directory and below"
is such a big deal in the first place.

If the user wants to apply a patch that touches ../etc/shadow, is
the tool in the place to complain?"
