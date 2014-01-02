Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaABVZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:25:48 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:38028 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaABVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:25:47 -0500
X-Authority-Analysis: v=2.0 cv=dq5Z+ic4 c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=oVFiZj9fevMA:10 a=V-dbX9k_FUIA:10 a=S1A5HrydsesA:10 a=Qsx_du5GiBkA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=KGjhK52YXX0A:10 a=PaGzra1uIP8A:10 a=QfKxxUxMAAAA:8 a=-JBMNkHz_a1-NH79rssA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <52C5D953.4030805@ubuntu.com>
Date: Thu, 02 Jan 2014 16:25:39 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrea Righi <andrea@betterlinux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, Greg Thelen <gthelen@google.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH v5 0/3] fadvise: support POSIX_FADV_NOREUSE
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com> <20120214133337.9de7835b.akpm@linux-foundation.org> <20120214225922.GA12394@thinkpad> <20120214152220.4f621975.akpm@linux-foundation.org> <20120215012957.GA1728@thinkpad> <20120216084831.0a6ef4f2.kamezawa.hiroyu@jp.fujitsu.com> <20120216004342.GB21685@thinkpad>
In-Reply-To: <20120216004342.GB21685@thinkpad>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

What ever happened to this patch set?  It looks like a great idea to
me and I'd *really* like to see this flag implemented.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSxdlTAAoJEI5FoCIzSKrw0O0H/3cIe/XvrXvF6qzgHpQPIfnN
a+14iqUa5+fNKNRM0Rwk9Tb3EFUjIXKHcRiRzGD9CINVxonBQQME68KA94UxVZIL
oul4YMP4dNcBhp8Ux1M80JY3Y/CMSo9SAN1pc7bmIezua/v821vb6wgCamj3EnS5
/Zs51cIWMkRSAr7EVvycI6mI04MzqsEdtGHdI0U6jrLjLLHsEgbuqkBMrc5BNkQ/
3tD6atY5zNyBIl+RBOvukNoijtEW4Z5OU+zfZHSk/L72yZnl+17nz4mRApmikUDV
zhJoCheWqLCLtpg2SxVC/EMUS3TDy3k9+8zQHbRZ3igXP4e58NZFR+XC1JhVonQ=
=TqVD
-----END PGP SIGNATURE-----
