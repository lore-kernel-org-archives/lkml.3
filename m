Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaACQlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:41:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaACQlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:41:01 -0500
Message-ID: <52C6E814.7090301@suse.cz>
Date: Fri, 03 Jan 2014 17:40:52 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Makefile: Build with -Werror=date-time if the compiler
 supports it
References: <cover.1387833347.git.josh@joshtriplett.org> <106ff2bbebe0c2c75bedf1c52a666d638b4dc20e.1387833347.git.josh@joshtriplett.org>
In-Reply-To: <106ff2bbebe0c2c75bedf1c52a666d638b4dc20e.1387833347.git.josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-23 22:56, Josh Triplett wrote:
> GCC 4.9 and newer have a new warning -Wdate-time, which warns on any use
> of __DATE__, __TIME__, or __TIMESTAMP__, which would make the build
> non-deterministic.  Now that the kernel does not use any of those
> macros, turn on -Werror=date-time if available, to keep it that way.

Nice, I didn't know about -Wdate-time. Do you want me to merge the
entire series, or do you want individual maintainers merge the patches?
In the latter case, I'd wait with applying 7/7 in order not to break the
build. At any rate, you can add

Acked-by: Michal Marek <mmarek@suse.cz>

Thanks,
Michal
