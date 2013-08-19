Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3HSB3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:29:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42916 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3HSB3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:29:33 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-fa-521174fb577d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wolfram Sang'" <wsa@the-dreams.de>
Cc: "'Wolfram Sang'" <wolfram@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
References: <003701ce8cfa$ba3fd060$2ebf7120$@samsung.com>
 <20130815180321.GB5934@katana>
In-reply-to: <20130815180321.GB5934@katana>
Subject: Re: [PATCH 05/35] i2c: use dev_get_platdata()
Date: Mon, 19 Aug 2013 10:29:31 +0900
Message-id: <015c01ce9c7b$8da0f710$a8e2e530$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGzz/5mKYgtFHg0uoEETYZ7GgxAVAIBkkSJmcFF+nA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zA93fJYJBBh8bxC2mPnzCZnF54SVW
	i46/XxgtLu+aw2bRs30mm8XKE7OYHdg8Nq3qZPPo27KK0ePkqScsHp83yQWwRHHZpKTmZJal
	FunbJXBlzJu1nLFgEndFy/f3jA2Mbzi6GDk5JARMJN6vXMQIYYtJXLi3nq2LkYtDSGAZo8TK
	KdeYYYpOrHjFAmILCUxnlHi7Lxei6BejxMyGz+wgCTYBNYkvXw6D2SJA9rOPXxlBipgFVjFK
	nF3ZxQzRHSXx4nkTmM0poC1x+NBhJhBbWMBMYt75HrA4i4CqxIcLG9hAbF4BS4k1+75D2YIS
	PybfA7uCWUBLYv3O40wQtrzE5jVvoS5VkNhx9jUjxBFWEsufzGCFqBGR2PfiHdhBEgLX2CXm
	3TrHBrFMQOLb5ENAQzmAErISmw5AzZGUOLjiBssERolZSFbPQrJ6FpLVs5CsWMDIsopRNLUg
	uaA4Kb3IRK84Mbe4NC9dLzk/dxMjJFon7GC8d8D6EGMy0PqJzFKiyfnAaM8riTc0NjOyMDUx
	NTYytzQjTVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2Mq99Q7aSWXHm9vbvD5
	HK+eJiTTF5Xd/8tUuI71b55g7qdX5zoXv1lteymj++/pb4tKVc7vZ5pjXRtX0Fa4brKh4O4H
	IpHtXV9fWj7p3ccYKKnEGuzT9m3uPa/XE9XftbIYnl2+9vSvvx4N0ZejxF/y36q78YZrbdjn
	eZfb9jEcURMotq6fLKfEUpyRaKjFXFScCACJdJeG7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jQd3fJYJBBs1PhSymPnzCZnF54SVW
	i46/XxgtLu+aw2bRs30mm8XKE7OYHdg8Nq3qZPPo27KK0ePkqScsHp83yQWwRDUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZsybtZyxYBJ3Rcv394wNjG84uhg5OSQETCRO
	rHjFAmGLSVy4t54NxBYSmM4o8XZfbhcjF5D9i1FiZsNndpAEm4CaxJcvh8FsESD72cevjCBF
	zAKrGCXOruxihuiOknjxvAnM5hTQljh86DATiC0sYCYx73wPWJxFQFXiw4UNYNt4BSwl1uz7
	DmULSvyYfA/sImYBLYn1O48zQdjyEpvXvGWGuFRBYsfZ14wQR1hJLH8ygxWiRkRi34t3jBMY
	hWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwKngmtYNxZYPF
	IUYBDkYlHl4LN8EgIdbEsuLK3EOMEhzMSiK8LGpAId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYS
	Tc4Hpqm8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamAMTlPc
	nhSxY4pE+JzYVf94w+f6n2B5r6/xaZVVxQ03g20XeyOWLXWO0dO5dkvl+Rzn4JnGHX2s8xbc
	K2aLeJE/3ebynaZJhh8eNNxnd1bUejLjibvQw4CjTCG5W446TZauC+WeIpy1YUuH+7Y3vTcD
	Zy7wuqbJop6g6GxfceLytaAVskynNTWUWIozEg21mIuKEwFpckouSQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 16, 2013 3:03 AM, Wolfram Sang wrote:
> On Tue, Jul 30, 2013 at 04:59:33PM +0900, Jingoo Han wrote:
> > Use the wrapper function for retrieving the platform data instead of
> > accessing dev->platform_data directly.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Not convincing. I couldn't find a cover letter explaining the motivation
> and if this should go via the seperate trees or via one cleanup pull
> request. (and if there is one, the i2c list should be on cc) Also, all

CC'ed Mark Brown (author of dev_get_platdata function)

1. Motivation
This is a cosmetic change by in order to enhance readability and make
the code simpler.

If you want, I will modify the commit message as below:
"Use the wrapper function for retrieving the platform data instead of
 accessing dev->platform_data directly. This is a cosmetic change
 in order to enhance readability and make the code simpler."

2. via the separate trees
It should go via the separate trees.

> 35 patches seem to be seperate mails and not threaded, so I can't easily
> check other opinions. Will skip for now unless somebody points out a
> strong reason.

3. Other opinions
Until now, there is no objection.
Also, 21 patches of all 35 patches have been applied by each maintainer.

Mark Brown,
Sorry for CC'ing you.
If I am wrong, please let me know kindly. :)

Best regards,
Jingoo Han

