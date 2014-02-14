Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBNCAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:00:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52216 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaBNCAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:00:08 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee691-b7efc6d0000039d3-90-52fd78a3cd66
Content-transfer-encoding: 8BIT
Message-id: <1392343111.25542.113.camel@kjgkr>
Subject: Re: [f2fs-dev] f2fs: f2fs unmount hangs if f2fs_init_acl() fails
 during mkdir syscall
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Andrey Tsyvarev <tsyvarev@ispras.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Date: Fri, 14 Feb 2014 10:58:31 +0900
In-reply-to: <52F9DF85.7040402@ispras.ru>
References: <52F320FC.50803@ispras.ru> <1391666564.25542.78.camel@kjgkr>
 <52F37D67.208@ispras.ru> <1391734185.25542.80.camel@kjgkr>
 <1391749933.25542.83.camel@kjgkr> <52F9DF85.7040402@ispras.ru>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zA93FFX+DDGau5LG4tMjd4vKuOWwW
	yy/HOTB7zPg3ldFj94LPTB6fN8kFMEdx2aSk5mSWpRbp2yVwZexcd52xYB5rxbUHE9gbGKew
	dDFyckgImEg0zD4GZYtJXLi3nq2LkYtDSGAZo8SVHx/gij4fPsUOYgsJTGeUOP42FsTmFRCU
	+DH5HlANBwezgLzEkUvZIGFmAXWJSfMWMUPMeckoMXP5a0aIej2JSctamUBsYYEEiak3b4P1
	sgloS2zebwAxXlHi7f67rCC2iICGxOqZP5kgZkZK3Dv5FmwMi4CqxI9nm9lAbE4BTYmdL7+w
	QOw6BnTzpFlgRfwCohKHF25nhrhfSWJ3eyc7SJGEwC52iemNt5khJglIfJt8COwICQFZiU0H
	oOolJQ6uuMEygVFiFpI3ZyG8OQvJmwsYmVcxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMTY
	xB2M9w9YH2JMBto4kVlKNDkfGKN5JfGGxmZGFqYmpsZG5pZmpAkrifOmP0oKEhJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cDYPE3ObfYus8X+sz4UP8rTeBcprmT8cIJiuTHTuol/VB6cKL92
	KJDt2scTedqvZ/LPuRc3YXeZ4NkZmQ2irB2ydzofNvqz8um76n06w/mhfs364o+hc+/M3su2
	Pblzx9WFSv33Qv9LJ+q2pvY849xzJsTMyEDFVvb0FLOvKevFIj894jygMz9KiaU4I9FQi7mo
	OBEAnlviCMcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQd3FFX+DDG51clpcWuRucXnXHDaL
	5ZfjHJg9Zvybyuixe8FnJo/Pm+QCmKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUN
	LS3MlRTyEnNTbZVcfAJ03TJzgPYoKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJA
	AwnrGDN2rrvOWDCPteLagwnsDYxTWLoYOTkkBEwkPh8+xQ5hi0lcuLeeDcQWEpjOKHH8bSyI
	zSsgKPFj8j2geg4OZgF5iSOXskHCzALqEpPmLWLuYuQCKn/JKDFz+WtGiHo9iUnLWplAbGGB
	BImpN2+D9bIJaEts3m8AMV5R4u3+u6wgtoiAhsTqmT+ZIGZGStw7+RZsDIuAqsSPZ5vBzuEU
	0JTY+fILC8SuY4wSVybNAiviFxCVOLxwOzPE/UoSu9s72ScwCs1CcvYshLNnITl7ASPzKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgCH4mvYNxVYPFIUYBDkYlHl6PB3+ChFgTy4orcw8x
	SnAwK4nwMqX9DRLiTUmsrEotyo8vKs1JLT7EmAx0+URmKdHkfGByySuJNzQ2MTOyNDKzMDIx
	NydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxtzgtHDhG2emSsYqNxZcWpecaR+0as/d
	uTVztJfLqz//0CsYduJ3aY/k4YgVBw+e+r9Bfm8QfzKDqNlZrx0Cz1Jdpzb5BV6t6lutkeN1
	9Xrhrfub2X9/d+O+YVdz76CEzc/0NMVby1ykZjxNubzURWad3aE5wXJ/J/k/VU9T2//Moe7L
	pkBjSSWW4oxEQy3mouJEAOXqXMgkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the late response.
I suffered from flu during last a couple of days. :(

2014-02-11 (화), 12:29 +0400, Andrey Tsyvarev:
> Hi,
> 
> > It turns out that make_bad_inode prior to iput sets i_mode to a regular
> > file, so that f2fs_evict_inode -> truncate_inode_pages ->
> > f2fs_invalidate_data_page doesn't decrement dirty_dents.
> >
> It seems that remove_dirty_dir_inode() call should also be added to the 
> error-path of
> init_inode_metadata, because its functionality is also based on 
> inode->i_mode field
> which is changed by make_bad_inode().

Agreed.
I'll update the patch with this.
Thanks,

-- 
Jaegeuk Kim
Samsung

