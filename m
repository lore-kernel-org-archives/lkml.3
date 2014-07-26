Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaGZNWA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 09:22:00 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:62018 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaGZNV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 09:21:58 -0400
X-AuditID: cbfec372-b7fe76d00000687e-e4-53d3ab7523bb
Date: Sat, 26 Jul 2014 10:21:51 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        "hans.verkuil" <hans.verkuil@cisco.com>, khalasa <khalasa@piap.pl>,
        Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] drivers/media/pci/solo6x10/solo6x10-disp.c: check
 kzalloc() result
Message-id: <20140726102151.239386d8.m.chehab@samsung.com>
In-reply-to: <20140726061311.GB25880@mwanda>
References: <1406313049-9604-1-git-send-email-andrey.utkin@corp.bluecherry.net>
 <CAM_ZknWPNyUCQkU+g4iJN47=cHMGPRuwoVe2Jh=4sciUM1t-NA@mail.gmail.com>
 <20140726061311.GB25880@mwanda>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/hIN3S1ZeDDb6sZbfo2viG3eL1v+ks
	Fkt+7mKyuP/oM7vF1lvSFu/+3mG0uLxrDptFz4atrA4cHlN+b2T1uPHhKrvHx6e3WDyePpjP
	4vF5k1wAaxSXTUpqTmZZapG+XQJXxsvbT5kLJrBX3P64hrGB8RxrFyMHh4SAicSWV0VdjJxA
	ppjEhXvr2boYuTiEBJYwSnTf3sgO4TQzSZy89IMNpIpFQFVi6oTdYDabgJHEq8YWVhBbREBH
	4nLnD7AGZoEFTBJL17xlAUkIC0RKrFn9ghnE5hWwkliyfxtYnBOoYc3O+6wQG3YwSrz7tosV
	4g5niZ8zJzFCNAhK/Jh8D6yBWUBLYvO2JlYIW15i85q3zBMYBWYhKZuFpGwWkrIFjMyrGEVL
	i5MLipPScw31ihNzi0vz0vWS83M3MUICvmgH47MNVocYBTgYlXh4N567FCzEmlhWXJl7iFGC
	g1lJhPfJ1MvBQrwpiZVVqUX58UWlOanFhxiZODilGhg7j9Q+VN4yjStD+mvh3TqhwIXpl2f/
	Ssr+lSW4UNHY2cnVsv3eziNKCkdP6Ox4ep/z5VyjzLsyE48cPJE0aa3D7O6PzffWlwu21Kj7
	RXbEq8rmCStvuWF17XjAEQ3/urC4vdZTXa0v7FpgFfnnyZykQL6lxr/zWZjXRUZ1bHji2LlG
	QlFzi5kSS3FGoqEWc1FxIgAdzPf8VgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 26 Jul 2014 09:13:12 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> On Fri, Jul 25, 2014 at 09:32:36PM +0300, Andrey Utkin wrote:
> > Please ignore. I didn't notice that Hans has already posted a patch
> > fixing that and more.
> > 
> 
> Heh.  I was just about to send my fix for this bug as well.
> 
> I don't follow linux-media so I didn't realize this driver was getting
> promoted out of staging.  I wish there was a way to go over drivers and
> fix any basic static checker fixes before promotion.

When I promote a driver out of staging, I run checkpatch again, in
order to check if everything is fine. It would be nice to have a
checkpatch-like script that would also run the static checker
checks for that particular patch. With that, I could, instead,
use such script when promoting patches or handling patches adding
new files to the Kernel.

Regards,
Mauro
