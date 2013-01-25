Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab3AYRwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:52:04 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25569 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab3AYRwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:52:01 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-c3-5102c63f62ff
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-13-git-send-email-arnd@arndb.de>
In-reply-to: <1359123276-15833-13-git-send-email-arnd@arndb.de>
Subject: RE: [PATCH 12/19] pinctrl: exynos: don't mark probing functions as
 __init
Date: Fri, 25 Jan 2013 09:51:39 -0800
Message-id: <00fc01cdfb24$a1c79b20$e556d160$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFOyAX6AHBSGkplwyQ5Yh9nQgcUJAJTxqzymUYa2jA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zA137Y0yBBt37jC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGk0czmAr+sFdsb/nN1MB4ja2LkZNDQsBE4tjtjawQtpjEhXvr
	geJcHEICyxglpl58zART9OTDaxaIxCJGiYv3p0JVzWOSuPjvKjtIFZuAhsTh98/AbBEBD4nz
	iy4A2RwczAJFEjNOgQ0SAjLXP5vMDGJzCthLbJxzhAXEFhYIkbi8dg9YK4uAqkTbsrtg1/EK
	WErc+3qHFcIWlPgx+R5YPbOAlsT6nceZIGx5ic1r3jJDHKogsePsa0aIE6wkPr2+ywxRIy4x
	6cFDdoia6ewSMzYIQewSkPg2+RALyJkSArISmw5AjZGUOLjiBssERolZSDbPQrJ5FpLNs5Bs
	WMDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjJLKkdjCubLA4xCjAwajEw+uxgClQiDWx
	rLgy9xCjBAezkgivjAlQiDclsbIqtSg/vqg0J7X4EGMy0LETmaVEk/OBUZ9XEm9obGxiZmJq
	Ym5pam5KmrCSOC/jqScBQgLpiSWp2ampBalFMFuYODilGhgrv2v88FR5tUWvJ699shY/yyez
	bQdWBil9CYlPMeNeZbF+g+WjxnbGJ5N4zpyeZ/g54tPz3Awh6wN8/6ynHrBz2vpj5sf73ucl
	/zt21djPEb63klv5R0/whatNDlkWwTpvSuNmXOjf98OsxY37PlNOz/89L89siYjJYfOZ8Nq+
	hsXRfM6Lp3lKLMUZiYZazEXFiQDB+/qr8AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgK79MaZAg1t3dC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpNHM5gK/rBXbG/5zdTA
	eI2ti5GTQ0LAROLJh9csELaYxIV764HiXBxCAosYJS7enwrlzGOSuPjvKjtIFZuAhsTh98/A
	bBEBD4nziy4A2RwczAJFEjNOMYGEhYDM9c8mM4PYnAL2EhvnHAFbICwQInF57R6wVhYBVYm2
	ZXfBjuAVsJS49/UOK4QtKPFj8j2wemYBLYn1O48zQdjyEpvXvGWGOFRBYsfZ14wQJ1hJfHp9
	lxmiRlxi0oOH7BMYhWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZw5D6T2sG4ssHiEKMAB6MSD6/HAqZAIdbEsuLK3EOMEhzMSiK8MiZAId6UxMqq1KL8+KLS
	nNTiQ4zJQJ9OZJYSTc4HJpW8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJzU5NLUgt
	gtnCxMEp1cBob6LqWL6cQ2x+FMdC6eqE6rZKqwXd6w8/yc+1cVv3VPg40wXNLtm//itXPBD+
	w8wTrBuewRLVYNj6vld84w7VjN9Cqs1zi6Q/hKVJd2dpB3u5anzs/PhLJ+j6UXXffyaTDvuY
	RtU++9r9u4zb6VHUGt+FLr+uJy6W2Np3Xqkvr1elYcHa1UosxRmJhlrMRcWJAN8hffYgAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> 
> Functions called from a driver probe() method must not be
> marked __init, because they may get called after the
> init phase is done, when the device shows up late, or
> because of deferred probing.
> 
> Without this patch, building exynos_defconfig results in
> multiple warnings like:
> 
> WARNING: drivers/pinctrl/built-in.o(.text+0x51bc): Section mismatch in
> reference from the function exynos5440_pinctrl_probe() to the
> function .init.text:exynos5440_gpiolib_register()
> The function exynos5440_pinctrl_probe() references
> the function __init exynos5440_gpiolib_register().
> This is often because exynos5440_pinctrl_probe lacks a __init
> annotation or the annotation of exynos5440_gpiolib_register is wrong.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

