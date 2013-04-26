Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836Ab3DZJ62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:58:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759782Ab3DZJ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:58:26 -0400
Message-ID: <517A4FC1.3070605@suse.cz>
Date: Fri, 26 Apr 2013 11:58:25 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: Re: linux-next: Tree for Apr 26
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au> <CA+icZUWt_W5FUQgQ2TFoQU0df+sAbxZZE8AcD16T3f_fiTD9DQ@mail.gmail.com>
In-Reply-To: <CA+icZUWt_W5FUQgQ2TFoQU0df+sAbxZZE8AcD16T3f_fiTD9DQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Yann, from whom I merged couple of kconfig changes yesterday.

On 26.4.2013 11:42, Sedat Dilek wrote:
> [ CC linux-kbuild folks ]
> 
> I am always doing a ...
> 
>    $ cd linux-next/
> 
>    $ yes "" | make oldconfig
> 
> ... before starting a kernel-build.
> 
> Today, I see this ...
> 
> $ ./scripts/build_linux-next.sh
> make options ...... CC=gcc-4.6 -j4
> KBUILD_BUILD_USER=sedat.dilek@gmail.com
> LOCALVERSION=-next20130426-1-iniza-small
> dep-pkg options ... KDEB_PKGVERSION=3.9.0~rc8~next20130426-1~iniza+dileks1
> scripts/kconfig/conf --silentoldconfig Kconfig
> *
> * Restart config...
> *
[...]
>   Enumeration method [M/y/?] (NEW) aborted!
> 
> Console input/output is redirected. Run 'make oldconfig' to update
> configuration.
> 
> make[2]: *** [silentoldconfig] Error 1
> make[1]: *** [silentoldconfig] Error 2
> make: *** No rule to make target `include/config/auto.conf', needed by
> `include/config/kernel.release'.  Stop.
> 
> Had only a quick view!
> 
> Temp. workaround: cd build-dir, run manually 'make oldconfig'.
> 
> Explanations welcome :-)!

Can you send a copy of your .config?

Thanks,
Michal


