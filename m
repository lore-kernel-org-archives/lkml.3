Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657AbbA1Uol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:44:41 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:49660 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531AbbA1Uof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:44:35 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Behan Webster <behanw@converseincode.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, "Christopher Li" <sparse@chrisli.org>
Subject: Re: [PATCH] Mark inline functions as __maybe_unused
References: <1422422779-3876-1-git-send-email-behanw@converseincode.com>
Date: Wed, 28 Jan 2015 10:04:34 +0000
In-Reply-To: <1422422779-3876-1-git-send-email-behanw@converseincode.com>
	(Behan Webster's message of "Tue, 27 Jan 2015 21:26:19 -0800")
Message-ID: <yw1xtwzbb4r1.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Behan Webster <behanw@converseincode.com> writes:

> clang warns if inline functions aren't used. By making them __maybe_unused
> there is no warning for either gcc nor clang.

Are you sure about that?  I've never seen such behaviour from clang (or
any other compiler), and it would truly be idiotic.  If clang has taken
to warning about unused inline functions, that's a regression that needs
to be addressed in clang, not the kernel.

-- 
Måns Rullgård
mans@mansr.com
