Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaDTGY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 02:24:58 -0400
Received: from 1wt.eu ([62.212.114.60]:9874 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaDTGYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 02:24:47 -0400
Date: Sun, 20 Apr 2014 08:24:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: Bastien Armand <armand.bastien@laposte.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jake Champlin <jake.champlin.27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] staging: panel: fix sparse warnings.
Message-ID: <20140420062437.GB4037@1wt.eu>
References: <20140418160918.GA1258@plop.dartybox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418160918.GA1258@plop.dartybox.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bastien,

On Fri, Apr 18, 2014 at 06:09:18PM +0200, Bastien Armand wrote:
> This serie of two patch fix the following sparse warnings in panel.c :
> panel.c:1235:26: warning: incorrect type in argument 1 (different address spaces)
> panel.c:1235:26:    expected void const volatile [noderef] <asn:1>*<noident>
> panel.c:1235:26:    got char const *tmp
> panel.c:1353:20: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
> panel.c:1353:20:    expected int ( *write )( ... )
> panel.c:1353:20:    got int ( static [toplevel] *<noident> )( ... )
> panel.c:1591:17: warning: incorrect type in argument 1 (different address spaces)
> panel.c:1591:17:    expected void const volatile [noderef] <asn:1>*<noident>
> panel.c:1591:17:    got char *tmp
> panel.c:1620:20: warning: incorrect type in initializer (incompatible argument 2 (different address spaces))
> panel.c:1620:20:    expected int ( *read )( ... )
> panel.c:1620:20:    got int ( static [toplevel] *<noident> )( ... )
> 
> Changes since v1 :
> - splitted patch in two
> 
> Bastien Armand (2):
>   staging: panel: fix sparse warnings in keypad_read
>   staging: panel: fix sparse warnings in lcd_write

Just reviewed them both and I'm fine with these patches. You can
add my :

    Acked-by: Willy Tarreau <w@1wt.eu>

Willy

