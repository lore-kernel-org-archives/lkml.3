Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaHASAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:00:39 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39786 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaHASAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:00:38 -0400
Date: Fri, 1 Aug 2014 20:00:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/5] x86: entry_64.S: delete unused code
Message-ID: <20140801180033.GE13134@localhost.localdomain>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:48:14PM +0200, Denys Vlasenko wrote:
> A define, two macros and an unreferenced bit of assembly are gone.
> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Andy Lutomirski <luto@amacapital.net>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
